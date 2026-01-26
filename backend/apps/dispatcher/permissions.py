from rest_framework import permissions


class IsDispatcher(permissions.BasePermission):
    """
    Permission class to check if user is a dispatcher (manager or admin).
    """
    message = 'You must be a manager or admin to access this resource.'

    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        return request.user.role in ('manager', 'admin')
