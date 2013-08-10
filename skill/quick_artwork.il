/* -------------------------------------------------------------------
This skill is use to setup the artworkclass information
-------------------------------------------------------------------*/ 
axlCmdRegister("quickart" 'quickart)
procedure(quickart()
      let(()

	    ;delet the old films
	    delnum = 0
	    oldartlayerlist = car(list(axlGetParam("artwork")->groupMembers)) ;("top" "bottom")
	    oldartlayerlistcount = length(oldartlayerlist)
	    deloldartlayerlist = list()
	    while((oldartlayerlistcount-1 >= delnum)
			 	drlid = axlGetParam(strcat("artwork:" nth(delnum oldartlayerlist)))
			 	deloldartlayerlist = append1(deloldartlayerlist drlid)
			 	delnum = delnum+1
	    )
	    axlDeleteObject(deloldartlayerlist)
	     ;delet done
	     
			 /* -------------------------------------------------------------------
			 list of the films wait for creating 
			 -------------------------------------------------------------------*/ 
	    etchLayers = axlSubclasses("Etch")
            nEtchLayers = length(etchLayers)
            ncdrilled = 0
            for(i 1 nEtchLayers-1
              	     for(j i+1 nEtchLayers
              	        sprintf(drillToLayer "MANUFACTURING/NCLEGEND-%d-%d" i j)
              	        if((axlIsLayer(drillToLayer) != nil) then
              	        	drillFilm = list("BOARD GEOMETRY/OUTLINE")
              	        	drillFilm = append1(drillFilm drillToLayer)
              	        	l_params = '(0 0 0 600 125000 1 0 0 0 0 0 1 1 )
              	        	sprintf(drillname "DRILL_%d_%d" i j)
              	        	axlfcreate(drillname l_params drillFilm )
              	        	ncdrilled = 1
              	        )
              	     )
            )
            if((ncdrilled == 0)
		then axlUIConfirm("Please NC DRILL First")
            )
              	        		              
	    ;For all etch layer	      
	    for(i 1 nEtchLayers
	     	     etchlayer = nth(i-1 etchLayers) 
                     etchfilm = list("BOARD GEOMETRY/OUTLINE" strcat("ETCH/",etchlayer) 
                                   strcat("VIA CLASS/",etchlayer) strcat("PIN/",etchlayer))
                     sprintf(layername "LAYER%d_%s" i etchlayer)
                     if(axlDBGetLayerType(strcat("ETCH/",etchlayer)) == "CONDUCTOR" then 
                     	l_params = '(0 0 0 0 125000 1 0 0 0 0 0 1 1 )
                     else                     	
                     	l_params = '(0 0 0 0 125000 0 0 0 1 0 0 1 1 )
                     )                     					 
                     axlfcreate(layername l_params etchfilm )                      
            )				   
             
	     
           ; PASTEMASK_TOP
           l_params = '(0 0 0 600 125000 1 0 0 0 0 0 1 1 )					 
           axlfcreate("PASTEMASK_TOP" l_params '("BOARD GEOMETRY/OUTLINE" "PIN/PASTEMASK_TOP" "BOARD GEOMETRY/PASTEMASK_TOP"))
           ; PASTEMASK_BOTTOM
           axlfcreate("PASTEMASK_BOTTOM" l_params '("BOARD GEOMETRY/OUTLINE" "PIN/PASTEMASK_BOTTOM" "BOARD GEOMETRY/PASTEMASK_BOTTOM"))
           ;SOLDERMASK_TOP
           axlfcreate("SOLDERMASK_TOP" l_params '("BOARD GEOMETRY/OUTLINE" 
		                        "PIN/SOLDERMASK_TOP" "PACKAGE GEOMETRY/SOLDERMASK_TOP" "BOARD GEOMETRY/SOLDERMASK_TOP" ))
           ;SOLDERMASK_BOTTOM
           axlfcreate("SOLDERMASK_BOTTOM" l_params  '("BOARD GEOMETRY/OUTLINE" 
                                 "PIN/SOLDERMASK_BOTTOM" "PACKAGE GEOMETRY/SOLDERMASK_BOTTOM" "BOARD GEOMETRY/SOLDERMASK_BOTTOM" ))
           ;SILKSCREEN_TOP
           axlfcreate("SILKSCREEN_TOP" l_params '("BOARD GEOMETRY/OUTLINE"  
                                "REF DES/SILKSCREEN_TOP" "BOARD GEOMETRY/SILKSCREEN_TOP" "MANUFACTURING/AUTOSILK_TOP" ))
           ;SILKSCREEN_BOTTOM
           axlfcreate("SILKSCREEN_BOTTOM" l_params '("BOARD GEOMETRY/OUTLINE"  
                                "REF DES/SILKSCREEN_BOTTOM" "BOARD GEOMETRY/SILKSCREEN_BOTTOM" "MANUFACTURING/AUTOSILK_BOTTOM"))
           ;OUTLINE
           axlfcreate("OUTLINE" l_params '("BOARD GEOMETRY/OUTLINE"))
         
	)
)

	 