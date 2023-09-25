# Welcome to this demo project

All projects need good documantation. MkDocs is a lightweight

All projects are created with the following base line of files.

```bash
├── Makefile
├── README.md
├── images
│   ├── Dockerfile
│   ├── Dockerfile.extend
│   └── Dockerfile.plantuml
└── plantuml.config
```

Add your code here with for example `gradle init`.

## Create Documentation

In this repository the create is already done.
To create a a MkDocs project and Structurizr for C4.

``` bash
make create 
```

This will create a few new files and leave Structurizr running.

``` bash
.
├── docs
│   └── index.md
├── mkdocs.yml
└── structurizr
    └── workspace.dsl
```

## Working with C4

To start Structurizr run:

```bash
open http://localhost:8081
make structurizr
```

Edit the `workspace.dsl` with your editor of choice.
A quick demo is created as a base line.

## Working with MkDocs

```bash
open http://localhost:8000
make serve
```

This will first generate first generate C4 images to svg images and put them to docs/diagrams
Then it will start MkDocs in development mode on localhost:8000.

## Regenerate SVG images

```bash
make svg
```

Good Luck







