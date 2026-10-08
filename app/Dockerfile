FROM python:3.8
WORKDIR /app
ADD . /app
RUN pip install -r requirements.txt
ENV AWS_SECRET_ACCESS_KEY=cjQ6Nhz8aV4mW1pL0xT7rK2sY9uB3eF5gH8jD6nQ
EXPOSE 5000
CMD ["python", "app.py"]
