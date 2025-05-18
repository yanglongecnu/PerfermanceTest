#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define BLOCK_SIZE 4096 // 与物理块对齐
#define READ_BLOCKS 8

int main() {
    FILE *dev = fopen("/dev/sdb", "rb+"); // 需sudo执行
    if(!dev) {
        perror("打开块设备失败");
        exit(EXIT_FAILURE);
    }

    unsigned char buffer[BLOCK_SIZE * READ_BLOCKS];
    
    // 块读取
    size_t read_cnt = fread(buffer, BLOCK_SIZE, READ_BLOCKS, dev);
    if(read_cnt != READ_BLOCKS) {
        fprintf(stderr, "读取不完全，实际读取%zu块\n", read_cnt);
        if(ferror(dev)) perror("读取错误");
    }

    // 块写入（示例，危险操作需谨慎！）
    fseek(dev, 0, SEEK_SET);
    size_t write_cnt = fwrite(buffer, BLOCK_SIZE, READ_BLOCKS, dev);
    if(write_cnt != READ_BLOCKS) {
        fprintf(stderr, "写入失败，错误码:%d\n", ferror(dev));
    }

    fclose(dev);
    return 0;
}