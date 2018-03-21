moduleManager = new (D3NE.ModuleManager)([ 'Entrée' ], [ 'Sortie' ])

componentModule = new D3NE.Component 'Module',
  builder: (node) ->   
    if !node.data.module
      node.data.module =
        name: 'module'
        data:
          id: editor.id
          nodes: {}
    
    moduleManager.getInputs(node.data.module.data).forEach (i) =>
      if (i.title == 'Entrée')
        node.addInput(new D3NE.Input(i.name, numSocket))
      #/ else for another socket
    
    moduleManager.getOutputs(node.data.module.data).forEach (o) =>
      console.log o.name, numSocket
      node.addOutput new (D3NE.Output)(o.name, numSocket)
    
    ctrl = new (D3NE.Control)("<div class='module-control'><input readonly type='text'><button>Edit</button></div>", (el, c) =>
      el.querySelector('input').value = node.data.module.name
      el.querySelector('button').onmousedown = => openModule node.data.module
    )
    node.addControl ctrl

  worker: moduleManager.workerModule.bind(moduleManager)

componentInput = new (D3NE.Component)('Entrée',
  builder: (node) ->
    name = node.data.name or 'entrée'
    out = new (D3NE.Output)('Nombre', numSocket)
    ctrl = _createFieldControl('text', name, 'name', 'type the name')
    node.addOutput(out).addControl ctrl

  worker: moduleManager.workerInputs.bind(moduleManager)
)

componentOutput = new (D3NE.Component)('Sortie',
  builder: (node) ->
    name = node.data.name or 'sortie'
    inp = new (D3NE.Input)('Nombre', numSocket)
    ctrl = _createFieldControl('text', name, 'name', 'type the name')
    node.addInput(inp).addControl ctrl

  worker: moduleManager.workerOutputs.bind(moduleManager)
)

