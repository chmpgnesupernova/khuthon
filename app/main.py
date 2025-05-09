from fastapi import FastAPI, UploadFile, File
from app.model import predict
from PIL import Image
import io

app = FastAPI()

@app.post("/predict")
async def predict_image(file: UploadFile = File(...)):
    contents = await file.read()
    image = Image.open(io.BytesIO(contents))
    result = predict(image)
    return {"result": result}
