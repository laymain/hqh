class_name AbilityLibrary extends Resource

@export var abilities: Array[AbilityResource] = []

func get_ability(id: String) -> AbilityResource:
    for i in range(abilities.size()):
        var ability := abilities[i]
        if ability:
            if ability.id == id:
                return ability
        else:
            push_error("[AbilityLibrary] Ability[", i, "] is null.")
    return null
