#pragma once

#ifdef WIN32
#ifdef LIB_EXPORTS // DLL EXPORT
#define LIB_EXPORT __declspec(dllexport)
#ifdef FE_MPROTECT
#define LIB_MPROTECT_EXPORT __declspec(dllexport, align(4096))
#else // NOT FE_MPROTECT
#define LIB_MPROTECT_EXPORT __declspec(dllexport)
#endif // FE_MPROTECT
#else  // DLL IMPORT
#define LIB_EXPORT __declspec(dllimport)
#ifdef FE_MPROTECT
#define LIB_MPROTECT_EXPORT __declspec(dllimport, align(4096))
#else // NOT FE_MPROTECT
#define LIB_MPROTECT_EXPORT __declspec(dllimport)
#endif // FE_MPROTECT
#endif // LIB EXPORTS
#else  // NOT WIN32
#define LIB_EXPORT __attribute__((visibility("default")))
#define LIB_MPROTECT_EXPORT __attribute__((visibility("default")))
#endif // WIN32
