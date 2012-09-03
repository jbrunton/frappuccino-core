describe "core.resources.LocalMemoryRepository", ->

    db = new core.resources.LocalMemoryRepository

    it "stores records in memory", ->
    
        db.createResource "users", name: "John",
            success: (res) -> expect(res.id).toBe 1
        
    it "reads records from memory", ->
        
        db.get_resource "users", 1,
            success: (res) -> expect(res.name).toBe "John"
    
    it "stores cloned objects in memory", ->
    
        _res1 = null
        _res2 = null
        
        db.get_resource "users", 1,
            success: (res) -> _res1 = res
            
        _res1.name = "Ben"
        
        db.get_resource "users", 1,
            success: (res) -> _res2 = res
        
        expect(_res1.name).toBe "Ben"
        expect(_res2.name).toBe "John"

    it "updates objects in memory", ->
    
        data =
            id: 1
            name: "Ben"
    
        db.updateResource "users", data
        
        db.get_resource "users", 1,
            success: (res) -> expect(res.name).toBe "Ben"