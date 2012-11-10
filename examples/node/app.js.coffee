core = require('frappuccino-container').core

container = new core.Container

container.register_instance "foo", "bar"
console.log(container.resolve "foo")
