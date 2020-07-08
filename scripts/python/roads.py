from neo4j import GraphDatabase
import numpy as np
from sklearn.manifold import TSNE
import altair as alt
import altair_viewer

driver = GraphDatabase.driver("bolt://localhost", auth=("neo4j", "neo"))
with driver.session(database="foo") as session:
    result = session.run("""
    MATCH (p:Place)
    RETURN p.name AS place, p.node2vecMoreTraining AS embedding, p.community AS community, p.country AS country
    """)
    X = {row["place"]: {"embedding": row["embedding"], "community": row["community"], "country": row["country"]} for row in result}

X_embedded = TSNE(n_components=2, random_state=6).fit_transform([X[key]["embedding"] for key in X.keys()])

places = list(X.keys())
df = pd.DataFrame(data = {
    "place": places,
    "community": [f"Community-{X[place]['community']}" for place in places],
    "country": [X[place]['country'] for place in places],
    "x": [value[0] for value in list(X_embedded)],
    "y": [value[1] for value in list(X_embedded)]
})

chart = alt.Chart(df).mark_circle(size=60).encode(
    x='x',
    y='y',
    color='community',
    tooltip=['place', 'community', 'country']
).properties(width=800, height=500)

altair_viewer.display(chart)
