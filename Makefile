
.PHONY: all
all: test

%: %.s
	$(CC) -o $@ $< -no-pie -lGL -lGLU -lglut