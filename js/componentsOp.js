// Generated by CoffeeScript 2.3.0
//Ne pas oublier d'enregistrer l'opérateur dans les "components" et de l'ajouter au menu dans le main.coffee
var componentAdd, componentCos, componentDis, componentDiv, componentId, componentMult, componentNum, componentPow, componentRac, componentSin, componentSous, componentSquare, fn_builder, fn_worker, getNode, op_builder, op_worker;

getNode = function(id) {
  return editor.nodes.find((n) => {
    return n.id === id;
  });
};

componentNum = new D3NE.Component('Nombre', {
  builder: function(node) {
    var numControl, out1;
    out1 = new D3NE.Output('Nombre', numSocket);
    numControl = _createFieldControl('number', node.data.num, 'num');
    return node.addControl(numControl).addOutput(out1);
  },
  worker: function(node, inputs, outputs) {
    return outputs[0] = node.data.num;
  }
});

// Fonction identique pour toutes les fonctions
fn_builder = function(node) {
  var inp1, numControl, out;
  inp1 = new D3NE.Input('Nombre', numSocket);
  out = new D3NE.Output('Nombre', numSocket);
  numControl = new D3NE.Control('<input readonly type="number">', (el, control) => {
    return control.setValue = (val) => {
      return el.value = val;
    };
  });
  return node.addInput(inp1).addControl(numControl).addOutput(out);
};

// Fonction identique pour toutes les fonctions
fn_worker = function(val, node, inputs, outputs, module) {
  var node_temp;
  if (!module) {
    node_temp = getNode(node.id);
    node_temp.controls[0].setValue(val);
  }
  return outputs[0] = val;
};

componentId = new D3NE.Component('Identité', {
  builder: function(node) {
    return fn_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = inputs[0][0];
    return fn_worker(val, node, inputs, outputs, module);
  }
});

componentSquare = new D3NE.Component('Carré', {
  builder: function(node) {
    return fn_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = inputs[0][0] * inputs[0][0];
    return fn_worker(val, node, inputs, outputs, module);
  }
});

componentSin = new D3NE.Component('Sinus', {
  builder: function(node) {
    return fn_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = Math.sin(Math.PI / 180 * inputs[0][0]);
    return fn_worker(val, node, inputs, outputs, module);
  }
});

componentCos = new D3NE.Component('Cosinus', {
  builder: function(node) {
    return fn_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = Math.cos(Math.PI / 180 * inputs[0][0]);
    return fn_worker(val, node, inputs, outputs, module);
  }
});

componentRac = new D3NE.Component('Racine', {
  builder: function(node) {
    return fn_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = Math.sqrt(inputs[0][0]);
    return fn_worker(val, node, inputs, outputs, module);
  }
});

// Fonction identique pour tous les opérateurs binaires
op_builder = function(node) {
  var inp1, inp2, numControl, out;
  inp1 = new D3NE.Input('Nombre', numSocket);
  inp2 = new D3NE.Input('Nombre', numSocket);
  out = new D3NE.Output('Nombre', numSocket);
  numControl = new D3NE.Control('<input readonly type="number">', (el, control) => {
    return control.setValue = (val) => {
      return el.value = val;
    };
  });
  return node.addInput(inp1).addInput(inp2).addControl(numControl).addOutput(out);
};

// Fonction identique pour tout les opérateurs binaires
op_worker = function(val, node, inputs, outputs, module) {
  var node_temp;
  if (!module) {
    node_temp = getNode(node.id);
    node_temp.controls[0].setValue(val);
  }
  return outputs[0] = val;
};

componentAdd = new D3NE.Component('Ajouter', {
  builder: function(node) {
    return op_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = inputs[0][0] + inputs[1][0];
    return op_worker(val, node, inputs, outputs, module);
  }
});

componentSous = new D3NE.Component('Soustraire', {
  builder: function(node) {
    return op_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = inputs[0][0] - inputs[1][0];
    return op_worker(val, node, inputs, outputs, module);
  }
});

componentMult = new D3NE.Component('Multiplier', {
  builder: function(node) {
    return op_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = inputs[0][0] * inputs[1][0];
    return op_worker(val, node, inputs, outputs, module);
  }
});

componentDiv = new D3NE.Component('Diviser', {
  builder: function(node) {
    return op_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = inputs[0][0] / inputs[1][0];
    return op_worker(val, node, inputs, outputs, module);
  }
});

componentPow = new D3NE.Component('Puissance', {
  builder: function(node) {
    return op_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = Math.pow(inputs[0][0], inputs[1][0]);
    return op_worker(val, node, inputs, outputs, module);
  }
});

componentDis = new D3NE.Component('Distance', {
  builder: function(node) {
    return op_builder(node);
  },
  worker: function(node, inputs, outputs, module) {
    var val;
    val = Math.abs(inputs[0][0] - inputs[1][0]);
    return op_worker(val, node, inputs, outputs, module);
  }
});
