테스트 방법

가상환경 구축
cd 해서 폴더 들어가기
python test_inference.py --ckpt logs/train/runs/last_ckpt/checkpoints/last.ckpt --image Locustoidea.jpg --classes data/classes.txt

여기서 이미지 링크, 가중치파일 위치, 클래스 정보 담긴 파일 경로 입력 후 terminal에서 실행
