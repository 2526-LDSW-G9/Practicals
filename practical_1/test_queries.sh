#!/bin/sh
# SPARQL query tests against Fuseki server
# Usage: ./test_queries.sh [FUSEKI_URL]

ENDPOINT="${1:-http://localhost:3030/ds}"
PREFIX='PREFIX uni: <https://2526-ldsw-g9.github.io/Practicals/University.rdf#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>'

run_query() {
    local name="$1"
    local query="$2"
    echo "============================================"
    echo "TEST: $name"
    echo "--------------------------------------------"
    echo "$query"
    echo "--------------------------------------------"
    curl -s --fail -G \
        --header "Accept: text/csv" \
        --data-urlencode "query=${PREFIX} ${query}" \
        "$ENDPOINT"
    local status=$?
    echo ""
    if [ $status -ne 0 ]; then
        echo "FAILED (curl exit code: $status)"
    fi
    echo ""
}

# --- Query 1: All distinct students who are enrolled in at least one module ---
run_query "All distinct students enrolled in a module" "
SELECT DISTINCT ?student
WHERE {
    ?student a uni:Student ;
             uni:studies ?module .
}
ORDER BY ?student
"

# --- Query 2: People who are both a Teacher and a Student ---
run_query "People who are both Teacher and Student" "
SELECT ?person
WHERE {
    ?person a uni:Teacher .
    ?person a uni:Student .
}
"

# --- Query 3: Modules (subclasses of uni:Module) with no teacher assigned ---
run_query "Courses with no teacher teaching them" "
SELECT ?course
WHERE {
    ?course a ?cls .
    ?cls rdfs:subClassOf* uni:Module .
    FILTER NOT EXISTS { ?t uni:teaches ?course . }
}
"

# --- Query 4: Modules (subclasses of uni:Module) with no student enrolled ---
run_query "Courses with no student studying them" "
SELECT DISTINCT ?course
WHERE {
    ?course a ?cls .
    ?cls rdfs:subClassOf* uni:Module .
    FILTER NOT EXISTS { ?s uni:studies ?course . }
}
"

# --- Query 5: Module with the most enrolled students ---
run_query "Module with the most enrolled students" "
SELECT ?module (COUNT(DISTINCT ?student) AS ?enrolled)
WHERE {
    ?student a uni:Student ;
             uni:studies ?module .
}
GROUP BY ?module
ORDER BY DESC(?enrolled)
LIMIT 1
"