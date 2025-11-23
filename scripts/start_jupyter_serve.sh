#!/bin/bash

# === 激活虚拟环境 ===
source ~/.venvs/cs61a_learning/bin/activate

# === 启动 Jupyter Lab（无浏览器 + 指定 IP + 指定端口） ===
jupyter lab \
  --no-browser \
  --ip=0.0.0.0 \
  --port=8888 \
  --NotebookApp.token='' \
  --NotebookApp.password=''
