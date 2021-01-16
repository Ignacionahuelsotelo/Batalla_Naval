
org 100h

jmp inicio

; ***** DECLARACIONES ******
                                      
   num              db  2   
   decena           db 10

   baseUSAX         dw ?
   baseUSAY         dw ?
   
   baseURSSX        dw ?
   baseURSSY        dw ?  
   
   baseSecretaURSS  dw ?
   baseSecretaUSA   dw ?
   
   memoriaTurno     db ?
   
   coordenada_x     dw ?   
   coordenada_y     dw ?
   
   disparoUsuario   dw ?
   guardaBx         dw ?
   vectorDisparos   dw 0,0,0,0,0,0,0,0,0
   
   quienJuega       db ? 
   
   contadorGeneral  db  0  
   cantidadDeWsUsa  db 40
   cantidadDeWsUrss db 54
   
   intentosUSA      db  0
   intentosURSS     db  0
      
         
   mapa    db "00.............................................................................",10,13,
           db "01.............................WAR GAMES-1983..................................",10,13,
           db "02.............................................................................",10,13,
           db "03..........-.....:**:::*=-..-++++:............:--::=WWW***+-++-...............",10,13,
           db "04......:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.......",10,13,
           db "05.....-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.........",10,13,
           db "06..........+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-...........",10,13,
           db "07.........*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-..........",10,13,
           db "08..........:**WW=*=...............-++++:::::-:+::++++++:++++++++..............",10,13,
           db "09...........-+:...-..............:+++++::+:++-++::-.-++++::+:::-..............",10,13,
           db "10.............--:-...............::++:+++++++:-+:.....::...-+:...-............",10,13,            
           db "11.................-+++:-..........:+::+::++++++:-......-....-...---...........",10,13,
           db "12.................:::++++:-............::++:+:.............:--+--.-...........",10,13,
           db "13.................-+++++++++:...........+:+::+................--.....---......",10,13,
           db "14...................:++++++:...........-+::+::.:-................-++:-:.......",10,13,
           db "15....................++::+-.............::++:..:...............++++++++-......",10,13,
           db "16....................:++:-...............::-..................-+:--:++:.......",10,13,
           db "17....................:+-............................................-.....--..",10,13,
           db "18.....................:-......................................................",10,13,
           db "19.............................................................................",10,13,
           db "20..........UNITED STATES.........................SOVIET UNION.................",10,13,
           db "21.............................................................................",10,13,
           db "22   5   9   13   18   23   28   33   38   43   48   53   58   63   68   73   78$"

    
    msj1         db  10,13,"USA Ingrese la coordenada X de su base secreta:$"       
    msj2         db  10,13,"USA Ingrese la coordenada Y de su base secreta:$"  
    msj3         db  10,13,"URSS Ingrese la coordenada X de su base secreta:$"
    msj4         db  10,13,"URSS Ingrese la coordenada Y de su base secreta:$"
    
    comienzaUSA  db  10,13,"                       ******Comienza UNITED STATES******          ",10,13,"$"  
    comienzaURSS db  10,13,"                       ******Comienza SOVIET UNION******          ",10,13,"$"
          
    juegaUSA     db  10,13,"Juega UNITED STATES",10,13,"$"
    juegaURSS    db  10,13,"Juega SOVIET UNION",10,13,"$"
    
    mensaje1     db  10,13,"Ingrese la coordenada X:$"
    mensaje2     db  10,13,"Ingrese la coordenada Y:$"
    
    mjeRango     db  10,13,"La coordenada esta fuera de rango",10,13,"$"
        
    space        db  " ",10,13,"$"
    
    mjeGanaUsa   db  10,13,"El ganador es UNITED STATES!",10,13,"$"
    mjeGanaUrss  db  10,13,"El ganador es SOVIET UNION!",10,13,"$" 
    
    nombreArchivo db "Estadisticas.txt", 0
    handle        dw  0
    dondearch1    db "C:\emu8086\MyBuild\Estadisticas.txt", 0
    bufferdata    db 0,0,0,0,0,0,0,0,0,0,0,0,0,"$"
    vector        db 50 dup (0)
    cont          db  0 

    final         db 10,13,"Gracias por jugar",10,13,"$"
   
    
   
;******PROGRAMA PRINCIPAL******

inicio:                  
    call initJuego    
    call jugar     
    call guardarRanking    
    ret
        
   
;***** INICIALIZAR JUEGO *****

proc initJuego 
       
    call printMap
    call pedirBaseSecreta    
    call turnoAleatorio
    ret
              
endp
    
;***** JUGAR *****

proc jugar
    
    juego:    
        call printMap         
        call informarPaisTurno  
        call leerCoordenadas        
        call disparar          
        call descontarW         
        call informarResultado        
        ret
  
endp

;***** GUARDAR RANKING ******

proc guardarRanking
   
    mov dx, offset final
    mov ah, 09h
    int 21h  
      
    call manejoArchivo
  
    ret
    
endp    
    

;*****Procedimientos******
    
    proc espacio
        
        mov dx, offset space
        mov ah, 09h
        int 21h
        ret
        
    endp
        
        
    proc printMap
            
        call espacio
        mov ah,09h
        mov dx,offset mapa 
        int 21h
        ret
        
    endp
         
         
    proc pedirBaseSecreta
        
        UsaIngresaX:             
            mov dx, offset msj1
            mov ah, 09h
            int 21h 
               
            mov ah, 1
            int 21h 
            xor ah,ah
            sub ax, 30h
            mul decena
            mov bx, ax
            xor ax,ax       
            mov ah, 1
            int 21h 
            xor ah,ah
            sub ax, 30h
            add bx, ax
            mov baseUSAX, bx
                   
            cmp baseUSAX, 2              
            jl fueraRango                ;si la coordenada es menor a 2 esta fuera de rango        
            cmp baseUSAX, 33             
            jg fueraRango                ;si la coordenada es mayor a 33 esta fuera de rango
            jmp UsaIngresaY              
        
            fueraRango:        
                call espacio
                mov dx, offset mjeRango      ;avisa que la coordenada esta fuera de rango
                mov ah, 09h
                int 21h
                jmp UsaIngresaX              ;vuelve a pedir la coordenada
           
        UsaIngresaY:        
            mov dx, offset msj2
            mov ah, 09h
            int 21h 
        
            mov ah, 1
            int 21h
            xor ah, ah
            sub al, 30h
            mul decena
            mov bx, ax
            xor ax,ax       
            mov ah, 1
            int 21h
            xor ah, ah 
            sub ax, 30h
            add bx, ax
            mov baseUSAY, bx
        
            cmp baseUSAY, 21
            jg fueraRango2               ;si la coordenada es mayor a 22 esta fuera de rango
            call espacio
            
            xor cx,cx
            xor bx,bx
            xor dx,dx
            xor ax,ax
            
            mov cx, baseUSAY            ;cx tiene que contener el "y" ingresado
            mov ax, 81
            mul cx
            mov bx, ax
            mov dx,baseUSAX ; si contiene el "x" ingresado                
            add bx, dx
            mov baseSecretaUSA,bx            
            jmp UrssIngresaX
                      
            fueraRango2:        
                call espacio
                mov dx, offset mjeRango
                mov ah, 09h
                int 21h
                jmp UsaIngresaY
                
        UrssIngresaX:             
            mov dx, offset msj3
            mov ah, 09h
            int 21h 
        
            mov ah, 1
            int 21h
            xor ah, ah
            sub al, 30h
            mul decena
            mov bx, ax
            xor ax,ax       
            mov ah, 1
            int 21h
            xor ah, ah 
            sub ax, 30h
            add bx, ax
            mov baseURSSX, bx
        
            cmp baseURSSX, 34
            jl fueraRango3        
            cmp baseURSSX, 78
            jg fueraRango3
            jmp UrssIngresaY
        
            fueraRango3:        
                call espacio
                mov dx, offset mjeRango
                mov ah, 09h
                int 21h
                jmp UrssIngresaX
           
        UrssIngresaY:        
            mov dx, offset msj4
            mov ah, 09h
            int 21h 
        
            mov ah, 1
            int 21h
            xor ah, ah
            sub al, 30h
            mul decena
            mov bx, ax
            xor ax,ax       
            mov ah, 1
            int 21h
            xor ah, ah 
            sub ax, 30h
            add bx, ax
            mov baseURSSY, bx
                
            cmp baseURSSY, 21
            jg fueraRango4
            
            xor cx,cx
            xor bx,bx
            xor dx,dx
            xor ax,ax
            
            mov cx, baseURSSY            ;cx tiene que contener el "y" ingresado
            mov ax, 81
            mul cx
            mov bx, ax
            mov dx,baseURSSX ; si contiene el "x" ingresado                
            add bx, dx
            mov baseSecretaURSS,bx            
            jmp salida  
            
        
            fueraRango4:        
                call espacio
                mov dx, offset mjeRango
                mov ah, 09h
                int 21h
                jmp UrssIngresaY
        
        salida: 
            ret
        
    endp
         
         
    proc turnoAleatorio
        
        mov ah, 2ch       ;obtener datos del reloj
        int 21h
        
        xor ah, ah
        mov al, dl        ;milisegundos en AL        
        div num           ;resto queda en ah y va a ser entre 0 o 1
        mov cl,ah
        
        cmp cl, 0         
        je USA                    
        jmp URSS
                
        USA:
            call espacio 
            mov dx, offset comienzaUSA
            mov ah, 09h
            int 21h
            mov memoriaTurno, 0
            ret
        
        URSS:
            call espacio 
            mov dx, offset comienzaURSS
            mov ah, 09h
            int 21h
            mov memoriaTurno, 1                 
            ret
                         
    endp
         
         
    proc informarPaisTurno
   
        cmp memoriaTurno, 0
        je turnoUSA        
        jmp turnoURSS 
        
        turnoUSA:
            mov dx, offset juegaUSA
            mov ah, 09h
            int 21h
            mov quienJuega, 0
            add intentosUSA, 1
            mov memoriaTurno, 1                 
            ret
            
        turnoURSS:
            mov dx, offset juegaURSS
            mov ah, 09h
            int 21h
            mov quienJuega, 1
            add intentosURSS, 1
            mov memoriaTurno, 0                             
            ret        
             
    endp
         
           
    proc leerCoordenadas
          
        ingresaX:                
            mov dx, offset mensaje1
            mov ah, 09h
            int 21h 
                
            mov ah, 1
            int 21h
            sub al, 30h
            mul decena
            xor ah, ah
            mov coordenada_x, ax
            mov ah, 1
            int 21h
            sub al, 30h
            xor ah, ah
            add coordenada_x, ax
        
            cmp coordenada_x, 3
            jl fueraRango5        
            cmp coordenada_x, 78
            jg fueraRango5
            jmp ingresaY
        
            fueraRango5:        
                call espacio
                mov dx, offset mjeRango
                mov ah, 09h
                int 21h
                jmp ingresaX
           
        ingresaY:
              
            mov dx, offset mensaje2
            mov ah, 09h
            int 21h 
        
            mov ah, 1
            int 21h
            sub al, 30h
            mul decena
            xor ah, ah
            mov coordenada_y, ax
            mov ah, 1
            int 21h
            sub al, 30h
            xor ah, ah
            add coordenada_y, ax
            
            cmp coordenada_y, 00
            jle fueraRango6
            cmp coordenada_y, 20
            jg fueraRango6
            jmp salida2
        
            fueraRango6:        
                call espacio
                mov dx, offset mjeRango
                mov ah, 09h
                int 21h
                jmp ingresaY
        
        salida2:
            call espacio
        endp
        ret
        
        
    proc disparar
          
;     Disparo Usuario
        xor bx,bx
        mov contadorGeneral, 0
        mov cx, coordenada_y            ;cx tiene que contener el "y" ingresado
        mov ax, 81
        mul cx
        mov bx, ax
        mov si, coordenada_x            ; si contiene el "x" ingresado                
        add bx, si
        mov disparoUsuario, bx
                
      ;linea arriba:            
          sub bx, 83
          mov si, 0
          mov cx, 3 
          mov ax, 0
          mov guardaBx, bx
        
        ciclo:            
            mov bx, guardaBx           
            inc si
                        
            mov dx, bx
            add dx, si
                        
            cmp mapa[bx+si], 57h 
            je contador1                
            mov mapa[bx+si] ,0             
            mov guardaBx, bx
            
            mov bx, ax
            mov vectorDisparos[bx], dx 
            add ax, 2 
                                   
            loop ciclo
            jmp lineaMedio
        
            contador1:
                inc contadorGeneral
                mov mapa[bx+si] ,0
                mov guardaBx, bx
            
                mov bx, ax
                mov vectorDisparos[bx], dx 
                add ax, 2
                 
                loop ciclo
             
        lineaMedio: 
            
            mov bx, guardaBx
            add bx, 81
            mov si, 0
            mov cx, 3
            mov guardaBx, bx
             
        ciclo2: 
            mov bx, guardaBx           
            inc si
                        
            mov dx, bx
            add dx, si
                        
            cmp mapa[bx+si], 57h 
            je contador2                
            mov mapa[bx+si] ,0             
            mov guardaBx, bx
            
            mov bx, ax
            mov vectorDisparos[bx], dx 
            add ax, 2 
                                   
            loop ciclo2
            jmp lineaAbajo
        
            contador2:
                inc contadorGeneral
                mov mapa[bx+si] ,0
                mov guardaBx, bx
            
                mov bx, ax
                mov vectorDisparos[bx], dx 
                add ax, 2
                 
                loop ciclo2
        
        lineaAbajo:
            mov bx, guardaBx 
            add bx, 81
            mov si, 0
            mov cx, 3 
            mov guardaBx, bx
             
        ciclo3: 
            mov bx, guardaBx           
            inc si
                        
            mov dx, bx
            add dx, si
                        
            cmp mapa[bx+si], 57h 
            je contador3                
            mov mapa[bx+si] ,0             
            mov guardaBx, bx
            
            mov bx, ax
            mov vectorDisparos[bx], dx 
            add ax, 2 
                                   
            loop ciclo3
            jmp fin
        
            contador3:
                inc contadorGeneral
                mov mapa[bx+si] ,0
                mov guardaBx, bx
            
                mov bx, ax
                mov vectorDisparos[bx], dx 
                add ax, 2
                 
                loop ciclo3
        
        fin:
            endp
            ret
   

        
    proc descontarW
        
        cmp quienJuega, 0
        je descontarUrss 
        jmp descontarUsa
        
        descontarUrss:
            mov cl, contadorGeneral 
            sub cantidadDeWsUrss, cl            
            jmp salir
            
        descontarUsa:  
            mov cl, contadorGeneral      
            sub cantidadDeWsUsa, cl
        
        salir:    
    endp 
    ret
                
    
    proc informarResultado
        
        xor bx, bx
        xor cx, cx
        mov cx, 9
        mov si, 0
        
        recorrerVector:                   
            xor ax, ax
            mov ax, baseSecretaUSA
            cmp ax, vectorDisparos[bx+si]
            je ganaUrss
            xor ax, ax
            mov ax, baseSecretaURSS
            cmp ax, vectorDisparos[bx+si]
            je ganaUsa         
            add bx, 2 
            loop recorrerVector
                
        cmp cantidadDeWsUsa, 0
        jle ganaUrss
        
        cmp cantidadDeWsUrss, 0
        jle ganaUsa
        jmp juego
             
        ganaUrss:
            call printMap
            mov dx, offset mjeGanaUrss
            mov ah, 09h
            int 21h 
            
           ;Guardar en vector 
                                ;Ganador
            mov bx, 0
            mov vector[bx], 55h    
            inc bx 
            mov vector[bx], 52h
            inc bx 
            mov vector[bx], 53h
            inc bx 
            mov vector[bx], 53h
            
            inc bx               ;Intentos 
            xor ax, ax
            mov al, intentosURSS
            div decena 
            add al, 48
            add ah, 48  
            mov vector[bx], al
            inc bx
            mov vector[bx], ah
            
            inc bx 
            xor ax, ax
            mov al, intentosUSA
            div decena
            add al, 48
            add ah, 48  
            mov vector[bx], al
            inc bx
            mov vector[bx], ah
                                 ;Ws derribadas
            inc bx
            xor ax, ax
            mov al, 54                 
            sub al, cantidadDeWsUrss
            div decena
            add al, 48
            add ah, 48 
            mov vector[bx], al
            inc bx            
            mov vector[bx], ah
            inc bx
            xor ax, ax
            mov al, 40                 
            sub al, cantidadDeWsUsa 
            div decena
            add al, 48
            add ah, 48 
            mov vector[bx], al
            inc bx            
            mov vector[bx], ah
            
    endp 
    ret
            
            
        ganaUsa:
            call printMap
            mov dx, offset mjeGanaUsa
            mov ah, 09h
            int 21h
             
         ;Guardar en vector  
         
            mov bx, 0           ;Ganador
            mov vector[bx], 55h
            inc bx 
            mov vector[bx], 53h
            inc bx 
            mov vector[bx], 41h
            inc bx 
            mov vector[bx], 1fh 
                                
            inc bx               ;Intentos 
            xor ax, ax
            mov al, intentosURSS
            div decena 
            add al, 48
            add ah, 48  
            mov vector[bx], al
            inc bx
            mov vector[bx], ah
            
            inc bx 
            xor ax, ax
            mov al, intentosUSA
            div decena 
            add al, 48
            add ah, 48  
            mov vector[bx], al
            inc bx
            mov vector[bx], ah
                                 ;Ws derribadas
            inc bx
            xor ax, ax
            mov al, 54                 
            sub al, cantidadDeWsUrss
            div decena
            add al, 48
            add ah, 48 
            mov vector[bx], al
            inc bx            
            mov vector[bx], ah
            inc bx
            xor ax, ax
            mov al, 40                 
            sub al, cantidadDeWsUsa 
            div decena
            add al, 48
            add ah, 48 
            mov vector[bx], al
            inc bx            
            mov vector[bx], ah     
            
    endp 
    ret
      
    proc manejoArchivo
        
     ;crear archivo .txt   
        mov ax, @data
        mov ds, ax
        mov ah, 3ch
        mov cx, 0
        mov dx, offset nombreArchivo
        int 21h 
        
     ;guardar vector en el .txt (la estadistica)   
        mov bx, ax
        mov cx, 13
        mov dx, offset vector
        mov ah, 40h
        int 21h 
        
     ;cerrar archivo
        mov ah, 3eh                 ;
        mov bx, handle              ;Cerramos el archivo abierto
        int 21h
         
     ;Lectura de archivo    
        mov al, 00h                  ; setea modo lectura
        mov dx, offset dondearch1    ; nombre y ubicacion del archivo
        mov ah, 3dh                  ; ejecuta la interrupcion para abrir el 
        int 21h                      ; archivo en modo especificado en al.
    
        jc error                     ; consulta el carry flag,
        mov handle, ax               ; si hubo error, salta a etiqueta error
       
        mov cont, 0
        mov ax, 0
        mov dx, offset bufferdata       ; en bufferdata se guardara lo que se lee
      
     leer:
        mov ah, 3fh
        mov cx, 13                       ; cantidad de bytes q se leera del archivo            
        mov bx, handle                  ; debemos dejar en bx el handle del archivo
        int 21h
        jc error                        ; Si el carry se seteo en 1, hubo error en la lectura.
        cmp ax, 0                       ; Si ax=0 significa que llego al fin EOF.                   
        jz cerrar
        inc dx
        jmp leer
    
     error:
        ret
                      
    ;Impresion y Cierre                       
     cerrar:
        call espacio 
        
        mov ah, 09h
        mov dx, offset bufferdata
        int 21h
    
        mov ah, 3eh                 ;
        mov bx, handle              ;Cerramos el archivo abierto
        int 21h   
      
    endp
    ret
                                                         
                                                      