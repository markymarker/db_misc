
// Coerce values in array to strings
CREATE (:Person {id: [value in [1, "mark", 2.0] | toString(value)]})

