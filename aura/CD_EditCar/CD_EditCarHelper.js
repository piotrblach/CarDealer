
({
    loadCarModelOptions: function(component){
        let action = component.get("c.getCarModels");
        let carModelInputSelect = component.find("addCarModelInputSelect");
        let carModelOptions=[];
        action.setCallback(this, function(response) {
            let modelOptions = response.getReturnValue();
            for(var i=0;i< modelOptions.length;i++){
                carModelOptions.push({"class": "optionClass", label: modelOptions[i], value: modelOptions[i]});
            }
            carModelInputSelect.set("v.options", carModelOptions);
        });
        $A.enqueueAction(action);
    },
})