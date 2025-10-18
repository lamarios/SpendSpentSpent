generate-dsl:
	echo "Generating java DSL, you need an up to date Postgres DB running at localhost:5432, db name sss, user: postgres, password: postgres"
	mvn jooq-codegen:generate@jooq-codegen -Djooq.skip=false

docs-build:
	 mkdocs build -f mkdocs/mkdocs.yml -c -d ../docs/docs
docs-serve:
	mkdocs serve -f mkdocs/mkdocs.yml
