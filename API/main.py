from flask import *
from data import *

app = Flask(__name__)
# app.config[
#     'SQLALCHEMYDATABASEURI'] = 'postgresql://postgres:password@ldecast/blockbuster'


@app.route('/', methods=['GET'])
async def root():
    print("Hello from flask!")

###################################################### Cargar ######################################################


@app.route('/cargarTemporal', methods=['GET'])
async def cargarTemporal():
    await connection(MASSIVE)
    return {"Status": "Se completó la carga a la tabla temporal."}


@app.route('/cargarModelo', methods=['GET'])
async def cargarModelo():
    await connection(MODEL)
    return {"Status": "Se concluyó la carga del modelo."}

###################################################### Consultas ######################################################


@app.route('/consulta1', methods=['GET'])
async def consulta1():
    consulta = await connection(C1)
    return jsonify(consulta)


@app.route('/consulta2', methods=['GET'])
async def consulta2():
    consulta = await connection(C2)
    return jsonify(consulta)


@app.route('/consulta3', methods=['GET'])
async def consulta3():
    consulta = await connection(C3)
    return jsonify(consulta)


@app.route('/consulta4', methods=['GET'])
async def consulta4():
    consulta = await connection(C4)
    return jsonify(consulta)


@app.route('/consulta5', methods=['GET'])
async def consulta5():
    consulta = await connection(C5)
    return jsonify(consulta)


@app.route('/consulta6', methods=['GET'])
async def consulta6():
    consulta = await connection(C6)
    return jsonify(consulta)


@app.route('/consulta7', methods=['GET'])
async def consulta7():
    consulta = await connection(C7)
    return jsonify(consulta)


@app.route('/consulta8', methods=['GET'])
async def consulta8():
    consulta = await connection(C8)
    return jsonify(consulta)


@app.route('/consulta9', methods=['GET'])
async def consulta9():
    consulta = await connection(C9)
    return jsonify(consulta)


@app.route('/consulta10', methods=['GET'])
async def consulta10():
    consulta = await connection(C10)
    return jsonify(consulta)

###################################################### Eliminación ######################################################


@app.route('/eliminarTemporal', methods=['GET'])
async def eliminarTemporal():
    await connection(DELETETMP)
    return {"Status": "Tabla temporal eliminada."}


@app.route('/elminarModelo', methods=['GET'])
async def eliminarModelo():
    await connection(DELETEMODEL)
    return {"Status": "Modelo eliminado."}


if __name__ == 'main':
    app.run()
