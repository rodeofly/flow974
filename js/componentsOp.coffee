#Ne pas oublier d'enregistrer l'opérateur dans les "components" et de l'ajouter au menu dans le main.coffee

getNode = (id) ->
  editor.nodes.find (n) => n.id == id

componentNum = new (D3NE.Component)('Nombre',
  builder: (node) ->
    out1 = new (D3NE.Output)('Nombre', numSocket)
    numControl = _createFieldControl('number', node.data.num, 'num')
    node.addControl(numControl).addOutput out1

  worker: (node, inputs, outputs) ->
    outputs[0] = node.data.num
)

# Fonction identique pour tout les opérateurs binaires
op_builder = (node) ->
  inp1 = new (D3NE.Input)('Nombre', numSocket)
  inp2 = new (D3NE.Input)('Nombre', numSocket)
  out = new (D3NE.Output)('Nombre', numSocket)
  numControl = new (D3NE.Control)('<input readonly type="number">', (el, control) =>
    control.setValue = (val) => el.value = val
  )
  node.addInput(inp1).addInput(inp2).addControl(numControl).addOutput out
# Fonction identique pour tout les opérateurs binaires
op_worker = (val, node, inputs, outputs, module) ->
  if (!module)
    node_temp = getNode( node.id )
    node_temp.controls[0].setValue(val)
  outputs[0] = val
  

componentAdd = new (D3NE.Component)('Ajouter',
  builder: (node) -> op_builder(node)

  worker: (node, inputs, outputs, module) ->
    val = inputs[0][0] + inputs[1][0];
    op_worker(val, node, inputs, outputs, module)
)

componentSous = new (D3NE.Component)('Soustraire',
  builder: (node) -> op_builder(node)
  
  worker: (node, inputs, outputs, module) ->
    val = inputs[0][0] - inputs[1][0];
    op_worker(val, node, inputs, outputs, module)
)

componentMult = new (D3NE.Component)('Multiplier',
  builder: (node) -> op_builder(node)
  
  worker: (node, inputs, outputs, module) ->
    val = inputs[0][0] * inputs[1][0];
    op_worker(val, node, inputs, outputs, module)
)

componentDiv = new (D3NE.Component)('Diviser',
  builder: (node) -> op_builder(node)
  
  worker: (node, inputs, outputs, module) ->
    val = inputs[0][0] / inputs[1][0];
    op_worker(val, node, inputs, outputs, module)
)

componentPow = new (D3NE.Component)('Puissance',
  builder: (node) -> op_builder(node)
  
  worker: (node, inputs, outputs, module) ->
    val = Math.pow inputs[0][0], inputs[1][0]
    op_worker(val, node, inputs, outputs, module)
)

componentDis = new (D3NE.Component)('Distance',
  builder: (node) -> op_builder(node)
  
  worker: (node, inputs, outputs, module) ->
    val = Math.abs( inputs[0][0] - inputs[1][0])
    op_worker(val, node, inputs, outputs, module)
)
