
({
    loadCarModelOptions: function(component){
        let action = component.get("c.getCarModels");
        let carModelInputSelect = component.find("carModelInputSelect");
        let carModelOptions=[];
        action.setCallback(this, function(a) {
            carModelOptions.push({"class": "optionClass", label: 'All', value: ''});
            for(var i=0;i< a.getReturnValue().length;i++){
                carModelOptions.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            carModelInputSelect.set("v.options", carModelOptions);

        });
        $A.enqueueAction(action);
    },
})