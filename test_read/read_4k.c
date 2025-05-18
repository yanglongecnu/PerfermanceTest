#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 4096

int main() {
    FILE *file = fopen("./1/2/3/4/5/6/7/8/9/1.txt", "rb");
    if (!file) {
        perror("文件打开失败");
        return -1;
    }

    // 分配4K对齐内存（Linux/MacOS用aligned_alloc，Windows用_aligned_malloc）
    char *buffer = (char*)aligned_alloc(4096, BUFFER_SIZE);
    if (!buffer) {
        perror("内存分配失败");
        fclose(file);
        return -1;
    }

    size_t total_read = 0;
    while (1) {
        size_t bytes_read = fread(buffer, 1, BUFFER_SIZE, file);
        if (bytes_read == 0) {
            if (feof(file)) break;
            if (ferror(file)) {
                perror("读取错误");
                break;
            }
        }
        
        // 模拟数据处理（如写入到其他文件）
        printf("已读取 %zu 字节\n", bytes_read);
        total_read += bytes_read;
        // break;
    }

    printf("总计读取: %zu 字节\n", total_read);
    fclose(file);
    free(buffer);
    return 0;
}
