#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 50*4096
#define O_DIRECT	00040000

int main() {
    int fd = open("200kb_file", O_RDONLY | O_DIRECT);
    if (fd == -1) {
        perror("open");
        return 1;
    }

    FILE *fp = fdopen(fd, "rb");
    if (!fp) {
        perror("fdopen");
        close(fd);
        return 1;
    }

    char *buffer = malloc(BUFFER_SIZE);

    size_t total_read = 0;
    while (1) {
        size_t bytes_read = fread(buffer, 1, BUFFER_SIZE, fp);
        if (bytes_read == 0) {
            if (feof(fp)) break;
            if (ferror(fp)) {
                perror("读取错误");
                break;
            }
        }
        // 模拟数据处理（如写入到其他文件）
        printf("已读取 %zu 字节\n", bytes_read);
        total_read += bytes_read;
        break;
    }

    printf("总计读取: %zu 字节\n", total_read);
    fclose(fp);
    free(buffer);
    int a;
    scanf("%d",&a);
    return 0;
}
