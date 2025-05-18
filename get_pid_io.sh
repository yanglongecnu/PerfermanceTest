for pid in $(pidof fio); do
    echo "===== PID $pid I/O Stats ====="
    cat /proc/$pid/io
    echo ""
done