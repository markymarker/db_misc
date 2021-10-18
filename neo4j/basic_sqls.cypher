// Interesting Links:
// https://neo4j.com/developer/kb/understanding-non-existent-properties-and-null-values/


// Finding Option nodes with a given property value
match (n:Option {option: 'Large'}) return n
match (n:Option) where n.option = 'Large' return n


// Find nodes with no relations
match (n) where not (n)-[]-() return n
// Find nodes with no relation to an Option
match (n)-[]-(o) where not (n)-[]-(:Option) return n, o
// Find non-Option nodes with no relation to an Option
match (n)-[]-(o) where not (n)-[]-(:Option) and not (n:Option) return n, o


// Find Person nodes and always show email property, whether set/exists or not ("map projection")
match (n:Person) return p {.*, .email}
// Get a list of emails, filling in 'NOT SET' when email is null (COALESCE)
match (n:Person) return collect(coalesce(p.email, 'NOT SET')) as emails
// Use a default value in comparison
match (p:Person) where coalesce(p.optedIn, false) <> true return p

