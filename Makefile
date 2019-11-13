.PHONY: all
all:
	./make.sh
	git add *
	git commit -a -m "update"
