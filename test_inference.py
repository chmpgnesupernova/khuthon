import torch
from PIL import Image
from torchvision import transforms
from omegaconf import OmegaConf
from pest_rec.models.insect_pest_module import InsectPestLitModule

# 1. 경로 설정
ckpt_path = "logs/train/runs/2025-05-09_20-11-53/checkpoints/last.ckpt"
config_path = "logs/train/runs/2025-05-09_20-11-53/.hydra/config.yaml"
image_path = "test.jpg"            # 테스트할 이미지 파일명
classes_path = "classes.txt"       # 클래스 이름이 저장된 텍스트 파일

# 2. Config 불러오기
cfg = OmegaConf.load(config_path)

# 3. 모델 불러오기
model = InsectPestLitModule.load_from_checkpoint(ckpt_path, cfg=cfg)
model.eval()

# 4. 이미지 전처리 정의 (학습 시 transform 기준 맞춰야 함)
transform = transforms.Compose([
    transforms.Resize((224, 224)),  # 필요시 사이즈 수정
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],  # 학습 기준에 따라 수정
        std=[0.229, 0.224, 0.225]
    )
])

# 5. 테스트 이미지 불러오기
image = Image.open(image_path).convert("RGB")
input_tensor = transform(image).unsqueeze(0)

# 6. 예측 수행
with torch.no_grad():
    output = model(input_tensor)
    pred_class = output.argmax(dim=1).item()

# 7. 클래스 이름 불러오기
with open(classes_path, "r") as f:
    classes = [line.strip() for line in f.readlines()]

# 8. 결과 출력
print(f"✅ 예측 클래스 ID: {pred_class}")
print(f"🔍 예측 클래스 이름: {classes[pred_class]}")