# Linked Data and Semantic Web

Course at University of Twente.

## Ontology creation

Use Protégé

## SPARQL Endpoint

```console
docker build -t fuseki .
docker run -d --rm \
    -p 3030:3030 \
    -v fuseki-data:/fuseki/databases \
    fuseki
```

The data is persistent in the volume, so only need to run the following once. To upload a dataset:

```console
curl -X POST http://localhost:3030/ds/data \
    -H "Content-Type: application/rdf+xml" \
    --data-binary @docs/University.rdf
```

The Fuseki UI is available at <http://localhost:3030>.

Example query:

```sparql
PREFIX uni: <https://sbussemaker.github.io/2526-LDSW-Group-9/University.rdf#>

SELECT *
WHERE { 
    ?subject ?predicate uni:CSModule
}
LIMIT 25
```

## Ontology verification

Using the Docker image (v2) and WordNet-3.0 (<https://wordnet.princeton.edu/download/current-version>):

```console
docker run -ti --rm \
    -v ./WordNet-3.0:/usr/local/tomcat/WordNet \
    -p 8080:8080 mpovedavillalon/oops:v2
```

then go to <http://localhost:8080/OOPS/>.

## Documenation

```console
docker run -ti --rm \
  -v `pwd`/docs:/usr/local/widoco/in:Z \
  -v `pwd`/docs/html:/usr/local/widoco/out:Z \
  ghcr.io/dgarijo/widoco:v1.4.23 -ontFile in/University.rdf -outFolder out -rewriteAll
```

Documentation is available here: <https://sbussemaker.github.io/2526-LDSW-Group-9/html/index-en.html>.
