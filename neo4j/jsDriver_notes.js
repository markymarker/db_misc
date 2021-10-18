
tx.run('MERGE (bob:Person {name : {nameParam} }) RETURN bob.name AS name', {
  nameParam: 'Bob'
}).subscribe({
  onNext: function(record) {
    console.log(record.get('name'))
  },
  onCompleted: function() {
    console.log('First query completed')
  },
  onError: function(error) {
    console.log(error)
  }
})




// Run a Cypher statement, reading the result in a streaming manner as records arrive:
session
  .run('MERGE (alice:Person {name : {nameParam} }) RETURN alice.name AS name', {
    nameParam: 'Alice'
  })
  .subscribe({
    onNext: function(record) {
      console.log(record.get('name'))
    },
    onCompleted: function() {
      session.close()
    },
    onError: function(error) {
      console.log(error)
    }
  })

// or
// the Promise way, where the complete result is collected before we act on it:
session
  .run('MERGE (james:Person {name : {nameParam} }) RETURN james.name AS name', {
    nameParam: 'James'
  })
  .then(function(result) {
    result.records.forEach(function(record) {
      console.log(record.get('name'))
    })
    session.close()
  })
  .catch(function(error) {
    console.log(error)
  })

