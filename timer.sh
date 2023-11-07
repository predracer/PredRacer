#!/bin/bash

# 定义 analyse_app.sh 脚本的路径
ANALYZE_SCRIPT="./analyse_appnew.sh"

# 定义保存结果的文件
RESULT_FILE="analysis_results.txt"
RESULT_FILE1="analysis_results1.txt"
ERROR_FILE="error_log.txt"

# 清空之前的结果文件和错误文件（如果存在）
> "$RESULT_FILE"
> "$ERROR_FILE"

# 遍历文件夹中的所有 .apk 文件
for apk_file in *.apk; do
    if [ -f "$apk_file" ]; then
        echo "Analyzing $apk_file"

        # 记录开始时间
        start_time=$(date +%s.%N)

        # 尝试运行 analyse_app.sh 脚本
        output=$("$ANALYZE_SCRIPT" "$apk_file" 2>&1)
        script_exit_code=$?

        # 检查脚本是否成功执行
        if [ $script_exit_code -eq 0 ]; then
            # 记录结束时间
            end_time=$(date +%s.%N)
            # 计算运行时间并写入结果文件
            runtime=$(echo "$end_time - $start_time" | bc)
            echo "Runtime for $apk_file: $runtime seconds" >> "$RESULT_FILE"
        else
            echo "Error analyzing $apk_file: $output" >> "$ERROR_FILE"
        fi
        sleep 2
    fi
done

echo "Analysis complete. Results saved in $RESULT_FILE"
