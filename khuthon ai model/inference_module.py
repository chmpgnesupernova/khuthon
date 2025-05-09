import torch
from PIL import Image
from torchvision import transforms
from omegaconf import OmegaConf
from pest_rec.models.insect_pest_module import InsectPestLitModule

CKPT_PATH = "logs/train/runs/2025-05-09_20-11-53/checkpoints/last.ckpt"
CONFIG_PATH = "logs/train/runs/2025-05-09_20-11-53/.hydra/config.yaml"
CLASSES_PATH = "classes.txt"

cfg = OmegaConf.load(CONFIG_PATH)
model = InsectPestLitModule.load_from_checkpoint(CKPT_PATH, cfg=cfg)
model.eval()

with open(CLASSES_PATH, "r") as f:
    class_names = [line.strip() for line in f.readlines()]

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225]),
])

def predict_image(image: Image.Image) -> str:
    tensor = transform(image).unsqueeze(0)
    with torch.no_grad():
        output = model(tensor)
        pred_idx = output.argmax(dim=1).item()
    return class_names[pred_idx]