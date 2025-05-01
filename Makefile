generate-dsl:
	echo "Generating java DSL, you need an up to date Postgres DB running at localhost:5432, db name sss, user: postgres, password: postgres"
	mvn jooq-codegen:generate@jooq-codegen -Djooq.skip=false