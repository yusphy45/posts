postPath := ../workSpace/source/_posts
deploy:
	@if [ -d "$(postPath)" ]; then rm -rd $(postPath); fi
	@cp -f *.md $(postPath)
	@rm $(postPath)/README.md
	@cd ../workSpace; hexo deploy -g
