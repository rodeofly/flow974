delay = (ms, func) -> setTimeout func, ms

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
    'Message envoyé': componentMessageSend
  Évènement :
    'Alerte': alertComp
    'Entrée pressée': enterpressComp
    'Touche enfoncée': keydownComp
    'Évènement Message': componentMessageEvent
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

  $( "#telegram" ).hide()
  load "dataOp.json"
  
  $( "#Op" ).on "click", -> 
    load "dataOp.json"
    $( "#telegram" ).hide()
    
  $( "#Ev" ).on "click", -> 
    load "dataEv.json"
    $( "#telegram" ).hide()
    
  $( "#Ai" ).on "click", -> 
    load "dataAi.json"
    $( "#telegram" ).show()
