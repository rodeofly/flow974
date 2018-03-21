getNode = (id) ->
  editor.nodes.find (n) => n.id == id

componentAdd = new (D3NE.Component)('Ajouter',
  builder: (node) ->
    inp1 = new (D3NE.Input)('Number', numSocket)
    inp2 = new (D3NE.Input)('Number', numSocket)
    out = new (D3NE.Output)('Number', numSocket)
    numControl = new (D3NE.Control)('<input readonly type="number">', (el, control) =>
      control.setValue = (val) => el.value = val
    )
    node.addInput(inp1).addInput(inp2).addControl(numControl).addOutput out

  worker: (node, inputs, outputs, module) ->
    sum = inputs[0][0] + inputs[1][0];
    if (!module)
      node_temp = getNode( node.id )
      node_temp.controls[0].setValue(sum)
    outputs[0] = sum
)

componentSous = new (D3NE.Component)('Soustraire',
  builder: (node) ->
    inp1 = new (D3NE.Input)('Number', numSocket)
    inp2 = new (D3NE.Input)('Number', numSocket)
    out = new (D3NE.Output)('Number', numSocket)
    numControl = new (D3NE.Control)('<input readonly type="number">', (el, control) =>
      control.setValue = (val) => el.value = val
    )
    node.addInput(inp1).addInput(inp2).addControl(numControl).addOutput out

  worker: (node, inputs, outputs, module) ->
    sous = inputs[0][0] - inputs[1][0];
    if (!module)
      node_temp = getNode( node.id )
      node_temp.controls[0].setValue(sous)
    outputs[0] = sous
)

componentMult = new (D3NE.Component)('Multiplier',
  builder: (node) ->
    inp1 = new (D3NE.Input)('Number', numSocket)
    inp2 = new (D3NE.Input)('Number', numSocket)
    out = new (D3NE.Output)('Number', numSocket)
    numControl = new (D3NE.Control)('<input readonly type="number">', (el, control) =>
      control.setValue = (val) => el.value = val
    )
    node.addInput(inp1).addInput(inp2).addControl(numControl).addOutput out

  worker: (node, inputs, outputs, module) ->
    mult = inputs[0][0] * inputs[1][0];
    if (!module)
      node_temp = getNode(node.id)
      node_temp.controls[0].setValue(mult)
    outputs[0] = mult
)

componentDiv = new (D3NE.Component)('Diviser',
  builder: (node) ->
    inp1 = new (D3NE.Input)('Number', numSocket)
    inp2 = new (D3NE.Input)('Number', numSocket)
    out = new (D3NE.Output)('Number', numSocket)
    numControl = new (D3NE.Control)('<input readonly type="number">', (el, control) =>
      control.setValue = (val) => el.value = val
    )
    node.addInput(inp1).addInput(inp2).addControl(numControl).addOutput out

  worker: (node, inputs, outputs, module) ->
    div = inputs[0][0] / inputs[1][0];
    if (!module)
      node_temp = getNode( node.id )
      node_temp.controls[0].setValue(div)
    outputs[0] = div
)

componentPow = new (D3NE.Component)('Puissance',
  builder: (node) ->
    inp1 = new (D3NE.Input)('Number', numSocket)
    inp2 = new (D3NE.Input)('Number', numSocket)
    out = new (D3NE.Output)('Number', numSocket)
    numControl = new (D3NE.Control)('<input readonly type="number">', (el, control) =>
      control.setValue = (val) => el.value = val
    )
    node.addInput(inp1).addInput(inp2).addControl(numControl).addOutput out

  worker: (node, inputs, outputs, module) ->
    pow = Math.pow inputs[0][0], inputs[1][0]
    if (!module)
      node_temp = getNode( node.id )
      node_temp.controls[0].setValue(pow)
    outputs[0] = pow
)

componentDis = new (D3NE.Component)('Distance',
  builder: (node) ->
    inp1 = new (D3NE.Input)('Number', numSocket)
    inp2 = new (D3NE.Input)('Number', numSocket)
    out = new (D3NE.Output)('Number', numSocket)
    numControl = new (D3NE.Control)('<input readonly type="number">', (el, control) =>
      control.setValue = (val) => el.value = val
    )
    node.addInput(inp1).addInput(inp2).addControl(numControl).addOutput out

  worker: (node, inputs, outputs, module) ->
    dis = Math.abs( inputs[0][0] - inputs[1][0])
    if (!module)
      node_temp = getNode( node.id )
      node_temp.controls[0].setValue(dis)
    outputs[0] = dis
)
