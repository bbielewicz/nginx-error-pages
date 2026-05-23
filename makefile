default: generate-python

generate-bash:
	@bash generate.sh

generate-python:
	@python generate.py

clean:
	rm -rf error-pages error-pages.conf
