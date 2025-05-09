#!/usr/bin/env python3
import argparse
import sys
from pathlib import Path

import torch
from PIL import Image
from torchvision import transforms
import lightning.pytorch as pl

# 프로젝트 루트를 PYTHONPATH에 추가 (pest_rec 모듈을 찾기 위함)
sys.path.append(str(Path(__file__).resolve().parent))

from pest_rec.models.components.insect_pest_net import InsectPestClassifier
from pest_rec.models.insect_pest_module import InsectPestLitModule


def get_device() -> torch.device:
    if torch.cuda.is_available():
        return torch.device("cuda")
    if torch.backends.mps.is_available():
        return torch.device("mps")
    return torch.device("cpu")


@torch.no_grad()
def predict_one(
    ckpt_path: Path,
    image_path: Path,
    classes_path: Path,
    img_size: int = 224,
) -> None:
    # 1) 클래스 이름 로드
    class_names = [l.strip() for l in classes_path.open("r", encoding="utf-8") if l.strip()]
    num_classes = len(class_names)

    # 2) net 객체 생성 (output_size=num_classes)
    net = InsectPestClassifier(output_size=num_classes, freeze=False)

    # 3) LightningModule 로드 (net 인자 필수)
    model: pl.LightningModule = InsectPestLitModule.load_from_checkpoint(
        checkpoint_path=str(ckpt_path),
        net=net,
        strict=False
    )
    model.eval()
    device = get_device()
    model.to(device)

    # 4) 이미지 전처리
    preprocess = transforms.Compose([
        transforms.Resize((img_size, img_size)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                             std=[0.229, 0.224, 0.225]),
    ])
    img = Image.open(image_path).convert("RGB")
    input_tensor = preprocess(img).unsqueeze(0).to(device)

    # 5) 추론 및 출력
    logits = model(input_tensor)
    probs = torch.softmax(logits, dim=1).squeeze(0)
    conf, idx = probs.max(dim=0)
    print(f"[✓] {image_path.name} → 예측: {class_names[idx]} (confidence: {conf.item():.4f})")


def main():
    parser = argparse.ArgumentParser(
        description="Single-image inference for pest classification"
    )
    parser.add_argument(
        "--ckpt", type=Path, required=True,
        help="체크포인트 파일 경로 (예: logs/train/runs/.../checkpoints/last.ckpt)"
    )
    parser.add_argument(
        "--image", type=Path, required=True,
        help="추론할 이미지 파일 경로"
    )
    parser.add_argument(
        "--classes", type=Path, required=True,
        help="클래스 리스트가 적힌 classes.txt 경로"
    )
    parser.add_argument(
        "--img-size", type=int, default=224,
        help="이미지 Resize 크기 (default: 224)"
    )
    args = parser.parse_args()

    predict_one(
        ckpt_path=args.ckpt,
        image_path=args.image,
        classes_path=args.classes,
        img_size=args.img_size,
    )


if __name__ == "__main__":
    main()
