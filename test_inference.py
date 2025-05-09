# test_inference.py
"""
단일 이미지(또는 폴더)로 곧바로 추론만 수행하는 스크립트.
추가 의존성(uvicorn 등) 없이 requirements.txt만 설치돼 있으면 동작한다.

$ python test_inference.py \
    --ckpt logs/train/runs/2025-05-09_20-11-53/checkpoints/last.ckpt \
    --config logs/train/runs/2025-05-09_20-11-53/.hydra/config.yaml \
    --image test.jpg \
    --classes classes.txt
"""



import argparse
from pathlib import Path

import torch
from PIL import Image
from torchvision import transforms
from omegaconf import OmegaConf



# 로컬 모듈(Lightning 기반 Model)
from pest_rec.models.insect_pest_module import InsectPestLitModule


ckpt_path = "logs/train/runs/2025-05-09_20-11-53/checkpoints/last.ckpt"
config_path = "logs/train/runs/2025-05-09_20-11-53/.hydra/config.yaml"
classes_path = "data/classes.txt" 
 

def load_model(ckpt_path: Path, cfg):
    """checkpoint와 Hydra config를 이용해 모델 로드."""
    model = InsectPestLitModule.load_from_checkpoint(
        checkpoint_path=str(ckpt_path),
        cfg=cfg,
        map_location="cpu",       # GPU가 있으면 "cuda:0" 로 변경
    )
    model.eval()
    return model


@torch.no_grad()
def predict(model, image_path: Path, transform, class_names):
    """단일 이미지에 대해 클래스 예측."""
    image = Image.open(image_path).convert("RGB")
    inp = transform(image).unsqueeze(0)  # (1, C, H, W)
    output = model(inp)
    pred_idx = output.argmax(dim=1).item()
    return pred_idx, class_names[pred_idx]


def main(args):
    # 1) config & 클래스 이름 로드
    cfg = OmegaConf.load(args.config)
    with open(args.classes, "r") as f:
        class_names = [ln.strip() for ln in f]

    # 2) 모델 로드
    model = load_model(args.ckpt, cfg)

    # 3) 전처리 정의 (학습 시 설정에 맞게 필요하면 수정)
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(
            mean=[0.485, 0.456, 0.406],
            std=[0.229, 0.224, 0.225],
        ),
    ])

    # 4) 이미지 한 장 또는 폴더 일괄 추론
    targets = (
        sorted(args.image.glob("*")) if args.image.is_dir() else [args.image]
    )

    for img_path in targets:
        idx, name = predict(model, img_path, transform, class_names)
        print(f"{img_path.name:20s} → id={idx:3d}, class={name}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ckpt", type=Path, required=True, help="Lightning checkpoint(.ckpt)")
    parser.add_argument("--config", type=Path, required=True, help="Hydra config.yaml")
    parser.add_argument("--image", type=Path, required=True, help="이미지 파일 또는 폴더")
    parser.add_argument("—classes", type=Path, default="classes.txt", help="클래스명 txt")
    args = parser.parse_args()

    main(args)