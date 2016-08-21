deploy:
	@if [ -d "../workSpace/source/_posts" ]; then rm -rd ../workSpace/source/_posts; fi
	@mkdir ../workSpace/source/_posts
	@cp *.md ../workSpace/source/_posts
	@rm ../workSpace/source/_posts/README.md
	@cd ../workSpace
	@hexo deploy -g --cwd /home/workSpace/
