# Whats Hoop

<p align="center">
  <img src="https://github.com/CosimoGiani/whats_hoop/blob/master/img/read%20me%20logo.png" style="width:800px;">
</p>

Applicazione per facilitare la gestione e l'organizzazione delle attività di una squadra di basket. \
Progetto per l'esame di Human Computer Interaction tenuto dal professor Andrew D. Bagdanov e previsto dal corso di laurea magistrale in Ingegneria Informatica dell'Università degli Studi di Firenze, A.A. 2021/2022.

## Funzionalità
L'applicazione si rivolge in generale a tutti quegli utenti che sono allenatori o fanno parte di una squadra di basket e si trovano continuamente in difficoltà quando è il momento di organizzare le attività della squadra. In particolare, l'applicazione cerca di presentarsi come un'alternativa per tutti coloro che fanno uso di applicazioni di messaggistica come WhatsApp per la loro organizzazione, fatto che ovviamente implica maggiori sforzi e attenzioni da parte dell'utente.

In questo contesto, dopo essersi registrati a **Whats Hoop**, se ci si autentica come un utente **allenatore** saremo in grado di:
* Creare uno o più gruppi di squadra: esiste la possibilità di avere più gruppi di squadra all'interno dell'applicazione qualora un utente sia allenatore di più squadre.
* Aggiungere, rimuovere o modificare attività: è possibile pianificare in anticipo le attività di squadra come allenamenti o partite, specificando informazioni utili per i giocatori. 
* Gestire la propria squadra: nella apposita pagina l'allenatore sarà in grado di invitare nuovi giocatori, rimuovere se necessario quelli già presenti. Inoltre è stata implementata una funzionalità emersa durante la fase di *needfinding* che consiste nella possibilità da parte dell'allenatore di multare un giocatore, ovvero di assegnargli una piccolo debito di denaro, qualora l'atleta per esempio si presenti in ritardo ad uno degli eventi programmati.
* Inviare sondaggi alla squadra: l'allenatore per sapere quanti dei suoi giocatori saranno presenti alla prossima attività pianificata può inviare dei sondaggi nei quali chiedere la partecipazione a suddetta attività. Questa funzionalità si è resa necessaria a seguito del periodo pandemico per via del quale gli atleti si ritrovavano in situazioni di quarantena. Inoltre può visionare le risposte correntemente ricevute attraverso un comodo grafico.

Se invece ci si autentica come un utente **atleta**, una volta aver accettato l'invito ad una squadra si potrà:
* Visionare le attività programmate: è possibile vedere un riassunto di tutti gli eventi futuri e relative informazioni utili in modo pratico e immediato.
* Rispondere ai sondaggi: quando l'allenatore invia un sondaggio di partecipazione ad una delle attività, il giocatore sarà in grado di rispondere alla domanda votando con un semplice click.
* Consultare un riassunto delle proprie multe: per evitare eventuali incomprensioni con l'allenatore, l'atleta può vedere in anticipo l'ammontare delle proprie multe e prepararsi in anticipo i soldi, o leggere più in dettaglio il motivo della penalità qualora non si ricordi quando o perchè è stato multato. 

Per maggiori informazioni e una descrizione completa dell'applicazione si rimanda alla lettura del [report](https://github.com/CosimoGiani/whats_hoop/blob/master/Relazione_HCI_GianiCosimo.pdf).

## Tecnologie utilizzate
L'applicazione è stata implementata utilizzando **Flutter**, un framework open-source per la creazione di applicazioni multi-platform. Si tiene a precisare che, nonostante sia in grado di performare tranquillamente sia su Android che iOS, Whats Hoop è stata unicamente testata su dispositivi Android per limiti tecnologici del su creatore. Resta comunque intangibile il fatto che l'applicazione per la sua natura ibrida possa essere utilizzata anche su dispositivi iOS con semplici accorgimenti. \
Per quanto riguarda il database è stato fatto uso di **Firebase** - nello specifico è stato utilizzato **Firestore**: Firebase è un servizio di hosting che consente di usufruire di uno spazio di memorizzazione online nel quale salvare i dati richiesti dall'applicazione, gestendo al contempo il meccanismo di autenticazione.

## Applicazione
Di seguito sono riportate le schermate di login e di registrazione a Whats Hoop:

  <div align="center">
    <img src="https://github.com/CosimoGiani/whats_hoop/blob/master/img/login.png" style="width:250px;">
    <img src="https://github.com/CosimoGiani/whats_hoop/blob/master/screenshots/registrazione.png" style="width:250px;">
  </div>
  
Alcuni esempi di schermate (sinistra pagina attività programmate per un allenatore - destra pagina di votazione ad un sondaggio per un atleta):

  <div align="center">
    <img src="https://github.com/CosimoGiani/whats_hoop/blob/master/img/esempi%20schermate.png" style="width:600px;">
  </div>
  
Tutte le pagine e una breve descrizione delle loro funzionalità, sia lato *allenatore* sia lato *atleta*, sono consultabili [qui](https://github.com/CosimoGiani/whats_hoop/blob/master/screenshots/screenshots.pdf).

## Note
* L'immagine utilizzata nella schermata di login dell'applicazione è reperibile a questo [link](https://iconscout.com/illustration/basketball-players-playing-basketball-3359808).
* I nomi dei giocatori e degli allenatori presenti nel report e nelle immagini sono stati scelti in modo del tutto casuale.
