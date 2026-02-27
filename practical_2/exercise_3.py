from rdflib import Graph, Namespace, RDF, Literal, URIRef
from rdflib.namespace import XSD, FOAF

from pathlib import Path
from random import random

ontoUni = Path('../docs/University.rdf')

Uni = Namespace('https://2526-ldsw-g9.github.io/Practicals/University.rdf#')

# Load University ontology
g = Graph()
g.parse(str(ontoUni.resolve()), format='xml')


# a method that concatenates a random number to the values assigned to the literals that you added before (for example, on firstName, lastName, rdfs:comment, rdfs:seeAlso, etc)
# as well as adding object properties (e.g., foaf:knows among students and lecturers)

value = Literal(42, datatype=XSD.int)

for (subj, pred, obj) in g:
    if type(obj) is Literal:
        g.set((subj, pred, value))
    
    if subj == URIRef(Uni.student1):
            student2 = URIRef(Uni.student2)
            g.add((subj, FOAF.knows, student2))

# and a method to save the ontology file with these changes
outfile = Path('../docs/University_2.rdf')

with open(outfile, 'w') as f:
    f.write(g.serialize(format='ttl'))
