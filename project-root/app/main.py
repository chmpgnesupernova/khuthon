from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import shutil
from model.model import predict_image

app = FastAPI()

@app.post("/predict/")
async def predict(file: UploadFile = File(...)):
    with open(f"temp_image.png", "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    
    label, processed_image_url = predict_image("temp_image.png")

    return JSONResponse(content={
        "label": label,
        "processed_image_url": processed_image_url
    })
