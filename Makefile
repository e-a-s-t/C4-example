default: serve

.PHONY: all structurizr
MKDOCS=mkdocs-material.extended

extend:
	docker build -t ${MKDOCS} -f images/Dockerfile.extend .

create: extend
	docker run --rm -it -v ${PWD}/:/docs squidfunk/mkdocs-material new .
	docker run -it --rm -p 8081:8080 -v ${PWD}/structurizr:/usr/local/structurizr structurizr/lite

serve: svg extend
	docker run --rm -it -p "8000:8000" -v ${PWD}:/docs ${MKDOCS} 

structurizr:
	docker run -it --rm -p 8081:8080 -v ${PWD}/structurizr:/usr/local/structurizr structurizr/lite

cli:
	docker run -it --rm -v ${PWD}:/usr/local/structurizr structurizr/cli export -workspace /usr/local/structurizr/structurizr/workspace.dsl -format json
	docker run -it --rm -v ${PWD}:/usr/local/structurizr structurizr/cli export -workspace /usr/local/structurizr/structurizr/workspace.json -format plantuml -o /usr/local/structurizr/structurizr/plantuml

svg: cli
	docker build -t png:1337  -f images/Dockerfile.plantuml .
	docker run -it --rm -v ${PWD}:/workdir png:1337 -tsvg -config /workdir/plantuml.config -progress -o /workdir/docs/diagrams /workdir/structurizr/plantuml