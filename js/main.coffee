delay = (ms, func) -> setTimeout func, ms

moduleManager = new (D3NE.ModuleManager)([ 'Input' ], [ 'Output' ])

_createFieldControl = (type, value, key, placeholder = '') ->
  return new (D3NE.Control)("<input type=#{type} value=#{value} placeholder=#{placeholder}>", (el, c) =>
    upd = ->
      if type is 'number'
        c.putData key, parseFloat(el.value) or 0
      else
        c.putData key, el.value
      editor.eventListener.trigger 'change'

    el.addEventListener 'input', upd
    el.addEventListener 'mousedown',   (e) -> e.stopPropagation()
    el.addEventListener 'contextmenu', (e) -> e.stopPropagation()
    # prevent node movement when selecting text in the input field
    # prevent custom context menu
    upd()
)

numSocket = new (D3NE.Socket)('number', 'Number value', 'hint')

componentModule = new D3NE.Component 'Module',
  builder: (node) ->   
    if !node.data.module
      node.data.module =
        name: 'module'
        data:
          id: editor.id
          nodes: {}
    
    moduleManager.getInputs(node.data.module.data).forEach (i) =>
      if (i.title == 'Input')
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

componentInput = new (D3NE.Component)('Input',
  builder: (node) ->
    name = node.data.name or 'inp'
    out = new (D3NE.Output)('Number', numSocket)
    ctrl = _createFieldControl('text', name, 'name', 'type the name')
    node.addOutput(out).addControl ctrl

  worker: moduleManager.workerInputs.bind(moduleManager)
)

componentOutput = new (D3NE.Component)('Output',
  builder: (node) ->
    name = node.data.name or 'out'
    inp = new (D3NE.Input)('Number', numSocket)
    ctrl = _createFieldControl('text', name, 'name', 'type the name')
    node.addInput(inp).addControl ctrl

  worker: moduleManager.workerOutputs.bind(moduleManager)
)

componentNum = new (D3NE.Component)('Number',
  builder: (node) ->
    out1 = new (D3NE.Output)('Number', numSocket)
    numControl = _createFieldControl('number', node.data.num, 'num')
    node.addControl(numControl).addOutput out1

  worker: (node, inputs, outputs) ->
    outputs[0] = node.data.num
)



menu = new (D3NE.ContextMenu)(
  Nombre: componentNum
  Fonctions:
    Fonction: componentModule
    Entrée: componentInput
    Sortie: componentOutput
  Opération :
    Addition: componentAdd
    Soustration: componentSous
    Multiplication: componentMult
    Division: componentDiv
    Puissance: componentPow
    Distance: componentDis
  
  Comunication:
    Message: componentMessage
    'Message identique': componentMessageMatch
    'Envoyer message': componentMessageSend
  Evenement :
    'Alerte': alertComp
    'Entrée pressée': enterpressComp
    'Touche enfoncée': keydownComp
    Message: componentMessageEvent
  Action: ->
      alert 'ok'
      return
)

components = [
  componentNum
  componentAdd
  componentSous
  componentMult
  componentDiv
  componentPow
  componentModule
  componentInput
  componentOutput
  keydownComp
  enterpressComp
  alertComp
  componentMessageEvent
  componentMessageSend
  componentMessageMatch
  componentMessage
]

container = document.querySelector('#d3ne')
editor = null
header = document.querySelector('#moduleheader')
modulename = header.querySelector('input')

modulename.addEventListener 'input', =>
  moduleStackEditor[moduleStackEditor.length - 1].module.name = modulename.value

moduleStackEditor = []
canSave = true

saveModule = ->
  { module, data } = moduleStackEditor.pop() 
  console.log "module",module,"data",data
  module.data = editor.toJSON()
  await editor.fromJSON data
  editor.view.zoomAt editor.nodes
  if moduleStackEditor.length is 0
    header.style.display = 'none'
  else
    modulename.value = moduleStackEditor[moduleStackEditor.length - 1].module.name
  editor.eventListener.trigger 'change'
  return

openModule = (m) ->
  console.log m
  moduleStackEditor.push
    data: editor.toJSON()
    module: m
  header.style.display = 'inline'
  modulename.value = m.name
  await editor.fromJSON m.data
  editor.view.zoomAt editor.nodes
  editor.eventListener.trigger 'change'

editor = new (D3NE.NodeEditor)('demo@0.1.0', container, components, menu)
engine = new (D3NE.Engine)('demo@0.1.0', components)
moduleManager.setEngine engine

compile = ->
  await engine.abort()
  status = await engine.process(editor.toJSON())
  console.log status

$ -> 
  load = (file) ->
    $.getJSON file, (data) ->
      console.log data
      do =>
        await editor.fromJSON(data);
        editor.eventListener.on 'change connectioncreate connectionremove nodecreate noderemove', (_, p) => compile() if p
                
        editor.eventListener.on 'error', (err) => alertify.error err.message
        editor.view.zoomAt editor.nodes
        editor.view.resize()
        editor.eventListener.trigger 'change'

  $( "#telegram" ).show()
  load "dataAi.json"
  
  $( "#Op" ).on "click", -> 
    load "dataOp.json"
    $( "#telegram" ).hide()
    
  $( "#Ev" ).on "click", -> 
    load "dataEv.json"
    $( "#telegram" ).hide()
    
  $( "#Ai" ).on "click", -> 
    load "dataAi.json"
    $( "#telegram" ).show()
