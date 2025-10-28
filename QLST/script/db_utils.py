"""
Utility helpers shared by the database setup scripts.

The scripts aim to work with either ``mysql-connector-python`` or ``PyMySQL``.
Shared helpers for the database management scripts.

If neither driver is available the caller receives a descriptive error that
includes the connection details that were attempted.
"""
from __future__ import annotations

import hashlib
import os
from contextlib import contextmanager
from typing import Dict, Iterator, Tuple


class DatabaseDriverNotInstalled(RuntimeError):
    """Raised when no supported MySQL driver is available in the environment."""


def get_db_config() -> Dict[str, str]:
    """Return connection settings using environment variables as overrides."""
    return {
        "host": os.getenv("DB_HOST", os.getenv("MYSQL_HOST", "54.251.13.3")),
        "port": int(os.getenv("DB_PORT", os.getenv("MYSQL_PORT", "3306"))),
        "user": os.getenv("DB_USER", os.getenv("MYSQL_USER", "root")),
        "password": os.getenv("DB_PASSWORD", os.getenv("MYSQL_PASSWORD", "root")),
        "database": os.getenv("DB_NAME", os.getenv("MYSQL_DATABASE", "mydatabase")),
    }


def get_connection():
    """
    Create and return a MySQL connection object.

    Tries ``mysql-connector-python`` first and falls back to ``PyMySQL``. This
    keeps the scripts flexible regardless of which driver the user prefers.
    """
    config = get_db_config()
    errors = []

    try:
        import mysql.connector  # type: ignore

        return mysql.connector.connect(
            host=config["host"],
            port=config["port"],
            user=config["user"],
            password=config["password"],
            database=config["database"],
            autocommit=False,
        )
    except ModuleNotFoundError as exc:
        errors.append(f"mysql-connector-python not installed: {exc}")
    except ImportError as exc:  # pragma: no cover - guard for exotic import errors
        errors.append(f"mysql-connector-python import error: {exc}")

    try:
        import pymysql  # type: ignore

        return pymysql.connect(
            host=config["host"],
            port=config["port"],
            user=config["user"],
            password=config["password"],
            database=config["database"],
            autocommit=False,
            charset="utf8mb4",
            cursorclass=pymysql.cursors.Cursor,
        )
    except ModuleNotFoundError as exc:
        errors.append(f"PyMySQL not installed: {exc}")
    except ImportError as exc:  # pragma: no cover
        errors.append(f"PyMySQL import error: {exc}")

    details = "; ".join(errors) if errors else "Unknown driver error"
    config_line = ", ".join(f"{key}={value}" for key, value in config.items())
    raise DatabaseDriverNotInstalled(
        "Unable to establish a MySQL connection. "
        f"Tried mysql-connector-python and PyMySQL. Details: {details}. "
        f"Attempted configuration: {config_line}"
    )


@contextmanager
def db_cursor(commit: bool = True) -> Iterator[Tuple[object, object]]:
    """
    Provide a context manager that yields a connection and cursor.

    Any exception during the block triggers a rollback before re-raising.
    """
    connection = get_connection()
    cursor = connection.cursor()
    try:
        yield connection, cursor
        if commit:
            connection.commit()
    except Exception:  # pragma: no cover - defensive transaction handling
        connection.rollback()
        raise
    finally:
        cursor.close()
        connection.close()


def hash_password(plain_password: str) -> str:
    """
    Produce a SHA-256 hash that matches PasswordUtil.hashPassword in Java.
    """
    digest = hashlib.sha256()
    digest.update(plain_password.encode("utf-8"))
    return digest.hexdigest()


def print_connection_banner() -> None:
    """Debug helper to print the connection parameters being used."""
    cfg = get_db_config()
    friendly = " | ".join(f"{key}={value}" for key, value in cfg.items())
    print(f"Connecting to MySQL with settings: {friendly}")

