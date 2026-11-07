import pandas as pd
import psycopg2
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
import joblib 

try:
    conexion = psycopg2.connect(
        host="localhost",
        database="convive_ia",
        user="postgres",
        password="1234",
        port="5432"
    )

    print("=== CONECTANDO A LA BASE DE DATOS ===")

    query_zonas = """
    SELECT u.nombre, z.nombre_zona, r.estado
    FROM RESERVA r
    JOIN USUARIO u ON r.id_usuario = u.id_usuario
    JOIN ZONA_COMUN z ON r.id_zona = z.id_zona;
    """
    df_zonas = pd.read_sql(query_zonas, conexion)
    
    
    df_zonas['zona_num'] = df_zonas['nombre_zona'].astype('category').cat.codes
    df_zonas['estado_num'] = df_zonas['estado'].apply(lambda x: 1 if str(x).lower() == 'confirmada' else 0)

   
    X_zonas = df_zonas[['zona_num']]
    Y_zonas = df_zonas['estado_num']
    X_train_z, X_test_z, Y_train_z, Y_test_z = train_test_split(X_zonas, Y_zonas, test_size=0.2, random_state=42)
    
    modelo_zonas = DecisionTreeClassifier()
    modelo_zonas.fit(X_train_z, Y_train_z)
    
    print("\n✅ Modelo 1 (Reservas de Zonas Comunes) entrenado.")
    joblib.dump(modelo_zonas, 'modelo_zonas.pkl')
    print("📦 Exportado como 'modelo_zonas.pkl'")

     #Esto lo cambias de acuerdo a tus tablass 

    query_solicitudes = """
    SELECT tipo_solicitud, tiempo_horas, prioridad
    FROM SOLICITUD;
    """
    df_solicitudes = pd.read_sql(query_solicitudes, conexion)
    
    df_solicitudes['tipo_num'] = df_solicitudes['tipo_solicitud'].astype('category').cat.codes
    df_solicitudes['urgencia_num'] = df_solicitudes['prioridad'].apply(lambda x: 1 if str(x).lower() == 'alta' else 0)

    X_solic = df_solicitudes[['tipo_num', 'tiempo_horas']]
    Y_solic = df_solicitudes['urgencia_num']
    X_train_s, X_test_s, Y_train_s, Y_test_s = train_test_split(X_solic, Y_solic, test_size=0.2, random_state=42)
    
    modelo_urgencia = DecisionTreeClassifier()
    modelo_urgencia.fit(X_train_s, Y_train_s)
    
    print("\n✅ Modelo 2 (Urgencia de Solicitudes) entrenado.")
    joblib.dump(modelo_urgencia, 'modelo_urgencia.pkl')
    print("📦 Exportado como 'modelo_urgencia.pkl'")

    
    print("\n--- SIMULANDO CASOS NUEVOS ---")
    
    nueva_reserva = pd.DataFrame({'zona_num': [0]}) 
    pred_reserva = modelo_zonas.predict(nueva_reserva)
    print(f"Predicción Reserva: {'Confirmada' if pred_reserva[0] == 1 else 'Cancelada'}")

    
    nueva_solicitud = pd.DataFrame({'tipo_num': [1], 'tiempo_horas': [48]}) 
    pred_solicitud = modelo_urgencia.predict(nueva_solicitud)
    print(f"Predicción Solicitud (48h): {'🚨 URGENTE' if pred_solicitud[0] == 1 else '✅ NORMAL'}")

except Exception as error:
    print("Error:", error)
finally:
    if 'conexion' in locals():
        conexion.close()