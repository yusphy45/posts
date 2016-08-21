deploy:
	@rm -rd ../workSpace/source/_posts
	@cp *.md ../workSpace/source/_posts
	@rm ../workSpace/source/_posts/README.md
	@cd ../workSpace
	@hexo deploy -g --cwd /home/workSpace/
