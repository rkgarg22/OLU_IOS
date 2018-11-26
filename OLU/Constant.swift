//
//  Constant.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 07/05/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import Foundation
import UIKit

//App Delegate Class
let applicationDelegate = UIApplication.shared.delegate as! AppDelegate

let USER_DEFAULT_DESCRIPTION_Key = "descriptionKey"
let USER_DEFAULT_CATEGORY_Key = "Category"
let USER_DEFAULT_LOGIN_CHECK_Key = "islogin"
let USER_DEFAULT_USERTYPE = "userType"
let USER_DEFAULT_LATITUDE_Key = "Latitude"
let USER_DEFAULT_LONGITUDE_Key = "Longitude"
let USER_DEFAULT_ADDRESS_Key = "address"
let USER_DEFAULT_NAME_Key = "Name"
let USER_DEFAULT_EMAIL_Key = "email"
let USER_DEFAULT_ImageUrl_Key = "imageUrl"
let USER_DEFAULT_USERID_Key = "userId"
let USER_DEFAULT_LOGIN_CHECKTRAINER_Key = "islogin"
let USER_DEFAULT_DOB_Key = "dob"
let USER_DEFAULT_GENDER_Key = "gender"
let USER_DEFAULT_PHONE_Key = "phone"
let USER_DEFAULT_NAMETRAINER_Key = "Name"
let USER_DEFAULT_FIRSTNAME_Key = "FirstName"
let USER_DEFAULT_SECONDNAME_Key = "SecondName"
let USER_DEFAULT_EMAILTRAINER_Key = "email"
let USER_DEFAULT_ImageUrlTRAINER_Key = "imageUrl"
let USER_DEFAULT_USERIDTRAINER_Key = "userId"
let USER_DEFAULT_DEVICETOKEN = "deviceToken"
//let baseUrl = "http://ec2-13-58-57-186.us-east-2.compute.amazonaws.com/api/"

let baseUrl = "http://3.16.104.146/api/"

let lockedNotificationIdentifier = "LockedNotificaiton"
let appName = "OLU"
let serverErrorString = "Error del Servidor"
let ChooseImageString = "Choose Image"
let Camera = "Camera"
let Gallery = "Gallery"
let noCamera = "No Camera"
let viewCameraString = "Open Camera"

let wazeItunesUrl = "https://itunes.apple.com/us/app/waze-navigation-live-traffic/id323229106?mt=8"
//signUp
let enterFirstName = "Por favor, introduzca su nombre de pila"
let enterlastName = "Por favor ingrese su apellido"
let enterDateOfBirth = "Por favor, introduzca su fecha de nacimiento"
let enterGender = "Por favor seleccione su género"
let enterEmail = "Ingresa E-mail válido"
let validEmail = "Ingresa E-mail válido"
let enterPassword = "Ingresa contraseña"
let confirmPassword = "Por favor confirma la contraseña"
let misMatchPassword = "Contraseña mistch"
let groupSelectedAlert = "Por favor seleccione la cantidad de personas"
let enterDate = "Por favor seleccione la fecha"
let enterTime = "Por favor selecciona la hora"
let selectGroup = "Seleccione la categoría del grupo"
let enterDescription = "por favor ingrese la descripción"
let selectForm = "seleccione al menos una categoría"
let fifteenMinCheckAlert = "Por favor ingresa una hora mayor a los próximos 15 minutos"
let comprarAlert = "¿Estas seguro y confirmas que deseas comprar el plan seleccionado?"
let imageUpload = "Quieres actualizar tu perfil Imagen?"
let selectLatLong = "Seleccione latitud y longitud"
let nothingToUpdate = "Ahi esta. othing para actualizar"

let cancelMessageForFirst15 = "¿Estas seguro que deseas cancelar?"
let cancelMessageForAfter15 = "¿Estas seguro que deseas cancelar? Al confirmar, la sesión te será cobrada en su totalidad."
let cancelMessageForNext45 = "¿Estas seguro que deseas cancelar? Al confirmar, la sesión te será cobrada en su totalidad."
let cancelMessageForMore75 = "¿Estás seguro que deseas cancelar la sesión programada?"

let noInternetConnection = "Verifica la conexión"

let enterRating = "Por favor ingrese la calificación"
//agenda
let areYouSureReserver = "¿Seguro que quieres reservar?"

// logout
let logoutAlert = "¿Estás seguro que deseas cerrar sesión?"
// pending
let cancelAlertTrainer = "¿Estas seguro que deseas cancelar este entrenamiento?"
let cancelAlertUser = "¿Estas seguro que deseas cancelar?"

let plan1Confirmation = "¿Estas seguro que deseas comprar el plan de $300.000?"
let plan2Confirmation = "¿Estas seguro que deseas comprar el plan de $600.000?"
let plan3Confirmation = "¿Estas seguro que deseas comprar el plan de $900.000?"

let passwordSent = "Nueva contraseña enviada a su correo electrónico de registro"

let kickBoxingDescription = "Es un deporte que combina técnicas de boxeo y elementos de algunas artes marciales, de origen japonés y desarrollo occidental. Esta técnica ayuda a aumentar la fuerza, la definición muscular y mejora el desempeño cardiovascular.Se aprende una técnica de auto defensa efectiva que libera el estrés y eleva la autoestima.Es ideal para aquellas personas que quieran un deporte de alta liberación de energía y coordinación efectiva entre la mente y el cuerpo."

let cardioCrossfitDescription = "Es una disciplina de acondicionamiento físico basado en ejercicios y tecnicas variadas con movimientos funcionales ejecutados a alta intensidad según condición física del usuario. Se logra una combinación efectiva entre el fortalecimiento muscular y el trabajo cardiovascular. Es perfecto para quienes quieren lograr un mejor desempeño en otros deportes, tonificar los musculos y mejorar las condiciones físicas generales."

let strectingDescription = "Son ejercicios personalizados de estiramiento para llevar a cabo elongaciones de los diferentes músculos. Esto permite que se mantengan flexibles, liberar tensiones y mejorar los rangos de movimiento de las articulaciones, la coordinación y el equilibrio,según la necesidad del usuario. Es recomendado para quienes quieran mejorar su movilidad, equilibrio, fuerza y evitar lesiones."
let yogaDescription = "Es un conjunto de ejercicios y posturas basados en técnicas milenarias que buscan el equilibrio de la mente, el cuerpo y el espíritu. Por medio de una adecuada respiración, ejercicios y meditación se logra encontrar el balance perfecto en cada sesion.  Sus beneficios principales son la liberación del estrés y la ansiedad, la tonificacion corporal, aumento en la flexibilidad. Ideal para quienes buscan un espacio para descansar la mente mientras se realiza una practica milenaria y la posibilidad de encontrar una armonia entre la mente y el cuerpo a traves de la respiración."
let pilatesDescription = "Es una técnica que incorpora ejercicios que ayudan a mejorar la tonificación de los músculos (combinación de yoga y gimnasia) a través de una sucesión de movimientos fluidos. Ayuda a mejorar la concentración, la precisión, la respiración, el control y la fluidez.  Igualmente mejora la coordinación, el equilibrio, la agilidad, la flexibilidad y tonifica los músculos. Es una técnica recomendada para quienes quieran corregir posturas corporales, tonificar el cuerpo, reducir el estrés o desarrollar fuerza en alguna parte especifica del cuerpo luego de una lesión."
let danzaFitDescription = "Es una clase diferente y ágil donde hay una combinación de baile y ejercicio aeróbico. Se mezclan géneros musicales con canciones de ritmo rápido y lento con el fin de quemar calorías de forma divertida. Esta técnica tonifica los musculos, mejora la flexibilidad y el equilibrio mientras se queman calorias bailando.  Es una opción ideal para las personas que quieren lograr metas de una manera diferente y agradable."

let gimnasiaAdultoMayor = "Tiene como funcion especifica la introduccion de habitos y actitudes saludables del mundo de la gimnsasia para la tercera edad. Mejora la forma física de aquellos adultos que presentan algun problema muscular o locomotor. Les ayuda a activar la mente y el cuerpo de una manera segura y dirigida, para evitar lesiones o complicaciones. Es ideal para los adultos que quieran reducir sus niveles de stress y ansiedad y a la vez quieran mantener un estilo de vida saludable."

let fisioterapiaDescription = "Es una disciplina que a través de ejercicio terapéutico, masoterapia y electroterapia, tiene como objetivo facilitar el desarrollo, manutención y recuperación de la máxima funcionalidad y movilidad de la persona. Ideal para quienes buscan prevenir lesiones deportivas, o en caso de estar en una recuperación de alguna lesión tratada por un médico especialista. (Se recomienda una visita al médico especialista para indicaciones antes de empezar una sesión."

let  masajesDeportivos = "Es la técnica de masaje especificamente diseñada para los deportistas. Se realizan sesiones de acuerdo a los objetivos de cada persona, tales como acondicionar los musculos para el esfuerzo en algún deporte, prevenir lesiones en la fase de entrenamiento o de competencia y contribuir a la recuperación óptima de las diferentes áreas. Se recomienda para deportistas en momentos de estrés, para descansar los músculos luego de sesiones deportivas extenuantes o para preparar el cuerpo para algúna meta específica. "

//user popup
let acceptTitle = "¡Estamos  Listos!\nTu  OLU  ha  confirmado  la  reserva"
let acceptMessage = "Ten en cuenta que solo hasta los 75 minutos previos al inicio del servicio podrás cancelar sin cobro. A partir de ese momento, si cancelas no se hará devolución del dinero"

let acceptTitleFor2hr = "¡Estamos  Listos!\nTu  OLU  ha  confirmado  la  reserva"
let acceptBefore2hrMessage = "Ten en cuenta que solo durante los próximos 15 minutos podrás cancelar sin cobro.  A partir de ese momento, si cancelas no se hará devolución del dinero"

let declineTitle = "¡Lo  sentimos!"
let declineMessage = "Tu  OLU  parece  no  estar  disponible.  Te  invitamos  a  seleccionar  otro  entrenador  que  se  acomode  a  tu  necesidad."

let cancelTitle = "¡Lo  sentimos!"
let cancelMessage = "El  OLU  que  seleccionaste  no  puede  realizar  la  actividad.  Te  invitamos  a  ver  otros  especialistasdisponibles  según  tu  requerimiento."

let startSesion = "Se da INICIO a la ACTIVIDAD"
let endSession = "FIN de la ACTIVIDAD"

let autoCancelMessage = "Tu OLU parece no estra disponoble.\nTe invitamos a seleccionar otro entrenador que se acomode a tu necesidad."

let paymentConfirmPopUp = "Serás redireccionado por unos instantes a la página de Place to Pay donde podrás validar el método de pago y así poder continuar con la reserva."

let ratingMessage = "Gracias por hacer parte de el equipo OLU."
let ratingMessageFromUserSide = "Tu comentario ha sido enviando, muchas gracias por utilizar OLU. ¡Te esperamos pronto!"

let profileVerificaitonMessage = "Los cambios se verán reflejados en las próximas horas, una vez el administrador valide la información"

let addCategoryMessage = "Por favor verifica la información de las ACTIVIDADES para poder continuar con el proceso."

let enterPromoCode = "Por favor, introduzca promocode"

let paymentFromCardWarning = "El saldo en tu plan es inferior al valor de la sesión. La diferencia será cargada a tu tarjeta de crédito."

let recordatorio = "RECORDATORIO"
let subjectLocal = "Tienes una OLU actividad programada en 30 minutos"

let trainerRegistrationVerifyMessage = "Muchas gracias por registrarte como especialista de OLU. En los próximos días te estaremos contactando para seguir el proceso de vinculación."

let switchSelectedCardConfirmation = "La tarjeta de crédito seleccionada quedará como tu medio de pago principal."

let thereSpecialCharterThere = "Quitar el caracter especial"


//MARK: - Show alert
// MARK: showAlert Function
func showAlert (_ reference:UIViewController, message:String, title:String){
    var alert = UIAlertController()
    if title == "" {
        alert = UIAlertController(title: nil, message: message,preferredStyle: UIAlertControllerStyle.alert)
    }
    else{
        alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertControllerStyle.alert)
    }
    
    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
    reference.present(alert, animated: true, completion: nil)
}


func convertTime(timeString:String) -> String
{
    let inFormatter = DateFormatter()
    inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    inFormatter.dateFormat = "HH:mm:ss"
    
    let outFormatter = DateFormatter()
    outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    outFormatter.dateFormat = "hh:mm a"
    
    let date = inFormatter.date(from: timeString)!
    let stringTime = outFormatter.string(from: date)
    return stringTime
    
}

func getDateInFormat(selectedDate: String)->String{
    var convertedDate = String()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) //Current time zone
    let firstConvertedDate = dateFormatter.date(from: selectedDate) //according to date
    
    dateFormatter.dateFormat = "MMMM" //month
    dateFormatter.locale =  NSLocale(localeIdentifier: "es") as Locale?
    let monthName = dateFormatter.string(from: firstConvertedDate!)
    
    dateFormatter.dateFormat = "dd"
    let dateWeek = dateFormatter.string(from: firstConvertedDate!)
    convertedDate = dateWeek + "/" + monthName.capitalized
    return convertedDate
}




func getUserID() -> Int {
    let userdefault = UserDefaults.standard
    let currentUser = userdefault.value(forKey: USER_DEFAULT_USERID_Key) as? Int ?? 0
    return currentUser
}

func getTrainerID() -> Int {
    let userdefault = UserDefaults.standard
    let currentUser = userdefault.value(forKey: USER_DEFAULT_USERID_Key) as! Int
    return currentUser
}

func getDeviceToken() -> String{
    let userdefault = UserDefaults.standard
    let deviceToken = userdefault.value(forKey: USER_DEFAULT_DEVICETOKEN) as? String ??  ""
    return deviceToken
}

func getConvertedPriceString(myDouble:Double) -> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "es_CL")
    let priceConverted =  formatter.string(from: myDouble as! NSNumber) // $123"
    return priceConverted!
}


//get weekday Name
func getWeekdayName(date:Date)-> String{
    // get current week day name
    let formatterWeek = DateFormatter()
    formatterWeek.dateFormat = "EEEE" // weekday name
    formatterWeek.locale =  NSLocale(localeIdentifier: "es") as Locale?
    let dayInWeek = formatterWeek.string(from: date)
    return dayInWeek.capitalized
}

//get day
func getDay(date:Date)-> String{
    let formatterDate = DateFormatter()
    formatterDate.dateFormat = "dd"
    let dateWeek = formatterDate.string(from: date)
    return dateWeek
}

//get month Name
func getMonthName(date:Date)-> String{
    var monthName = String()
    let dateFormatterMonth = DateFormatter()
    dateFormatterMonth.dateFormat = "LLL" //month
    dateFormatterMonth.locale =  NSLocale(localeIdentifier: "es") as Locale?
    monthName = dateFormatterMonth.string(from: date)
    return monthName.capitalized
}


func getCatName(catID:Int)->String {
    
    var catName = String()
    
    switch catID {
    case 1 :
        catName = "Kickboxing"
        break;
    case 2 :
        
        catName = "Entrenamiento Funcional"
    case 3 :
        
        catName = "Stretching"
    case 4 :
        
        catName = "Yoga"
    case 5 :
        
        catName = "Pilates"
     case 11 :
        
        catName = "Dance Fit"
    case 10 :
        
        catName = "Gimnasia Adulto Mayor"
    case 9 :
        
        catName = "Fisioterapia"
    case 8 :
        
        catName = "Masajes Deportivos"
        
    default:
        
        catName = "Masajes Deportivos"
    }
    return catName
}


extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
