// This document breaks our < 80 character rule.
// Please enable word wrap and accept our apologies.

function setfocus() {
    if (document.forms.registerform.email.value == "") {
        document.forms.registerform.email.focus();
    }
    else {
      document.forms.registerform.password.focus();
    }
}

function checkform() {
    if (checkEmail() == false) {
        return false;
    }
    if (checkPassword() == false) {
        return false;
    }
    if (checkFirstname() == false) {
        return false;
    }
    if (checkIbname() == false) {
        return false;
    }
    if (checkLastname() == false) {
        return false;
    }
    if (checkCity() == false) {
        return false;
    }
    if (checkStreet() == false) {
        return false;
    }
    if (checkNumber() == false) {
        return false;
    }
    else {
        return true;
    }
}


/*
From http://www.w3schools.com/js/tryit.asp?filename=tryjs_form_validate_email
*/
function checkEmail() {
    var x = document.forms["registerform"]["email"].value;
    var atpos = x.indexOf("@");
    var dotpos = x.lastIndexOf(".");
    if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length) {
        alert("Please enter a valid email adress");
        return false;
    }
}

function checkPassword() {
    id = document.getElementById("pw");
    var short = "The password is too short.";
    short += "Please choose a password with at least 6 characters.";
    if (id.value.length <6) {
        alert(short);
        return false;
    }
    if (id.value.length >128) {
        alert("Please choose a password with at most 128 characters.");
        return false;
    }
}


function checkFirstname() {
    id = document.getElementById("fn");
    if (id.value.length >128) {
        alert("The firstname is too long. Please enter a firstname less than 128 characters.");
        return false;
    }
}

function checkIbname() {
    id = document.getElementById("ib");
    if (id.value.length >64) {
        alert("The inbetweenname is too long. Please enter an inbetweenname less than 64 characters.");
        return false;
    }
}
/*-----*/
function checkLastname() {
    id = document.getElementById("ln");
    if (id.value.length >256) {
        alert("The lastname is too long. Please enter a lastname less than 256 characters.");
        return false;
    }
}

function checkCity() {
    id = document.getElementById("ct");
    if (id.value.length >128) {
        alert("The name of the city is too long. Please enter a city name less than 128 characters.");
        return false;
    }
}


/*----*/

function checkStreet() {
    id = document.getElementById("st");
    if (id.value.length >128) {
        alert("The streetname is too long. Please enter streetname less than 128 characters.");
        return false;
    }
}
/* http://www.java2s.com/Code/JavaScript/Form-Control/Validateaninputfieldwithminimumandmaximumvalues.htm */
function checkNumber() {
    getForm = document.registerform;
    value = getForm.housenumber.value;
    if (value < 1) {
        alert("Please enter a legit housenumber larger than 0");
        return false;
    }
}
