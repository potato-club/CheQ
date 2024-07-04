package dev.oth.cheq.domains

data class PermissionCheckModel(
    val grant : Boolean,
    val rePromptAble : Boolean = false
)
