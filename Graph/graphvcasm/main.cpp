#define UNICODE

// WinAPI
#include <Windows.h>
#include <tchar.h>

// OpenGL
#pragma comment(lib, "Opengl32.lib")
#include <gl/GL.h>

// Глобальные константы
TCHAR *szWndClass = L"OpenGLWindow";

// Глобальные переменные
HWND  hWnd;
HDC   hDC;
HGLRC hRC;

int Angle = 0;

// Функции для создания окна Win32
ATOM RegClass(HINSTANCE hInst);
HWND CreateWnd(HINSTANCE hInst);
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

extern "C" char * DRAWQUAD();

// Функции для работы с OpenGL
void GLInit();
void GLRenderScene();
void GLShutdown();

int WINAPI wWinMain(HINSTANCE hInst, HINSTANCE hPrevInst, LPWSTR lpCmdLine, int nShowCmd)
{
	// Регистрация класса окна
	if (!RegClass(hInst))
	{
		MessageBox(0, L"Не могу зарегистрировать класс окна...", 0, 0);
		return 1;
	}

	// Создание окна
	hWnd = CreateWnd(hInst);
	if (hWnd == NULL)
	{
		MessageBox(0, L"Не могу создать окно...", 0, 0);
		return 1;
	}

	// Инициализация OpenGL
	GLInit();

	// Главный цикл приложения
	MSG msg;
	while (GetMessage(&msg, NULL, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return 0;
}

ATOM RegClass(HINSTANCE hInst)
{
	// Все стандартное, как и обычно, в WinAPI...
	WNDCLASS wc;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.hbrBackground = 0;
	wc.hCursor = LoadCursor(0, IDC_ARROW);
	wc.hIcon = 0;
	wc.hInstance = hInst;
	wc.lpfnWndProc = WndProc;
	wc.lpszClassName = szWndClass;
	wc.lpszMenuName = 0;
	wc.style = CS_HREDRAW | CS_VREDRAW; // Окно перерисовывается при растягивании

	return RegisterClass(&wc);
}

HWND CreateWnd(HINSTANCE hInst)
{
	// Создание окна - снова, все, как обычно...
	return CreateWindowW(szWndClass, 0,
		WS_VISIBLE | WS_SYSMENU | WS_SIZEBOX | WS_MAXIMIZEBOX | WS_MINIMIZEBOX,
		CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
		0, 0, hInst, 0);
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	PAINTSTRUCT ps;
	

	switch (msg)
	{
	case WM_PAINT:
		BeginPaint(hWnd, &ps);
		GLRenderScene(); // Рендеринг (отрисовка) сцены
		EndPaint(hWnd, &ps);
		break;
	case WM_SIZE:
		// При растягивании - получение размера окна...
		RECT rect;
		GetClientRect(hWnd, &rect);
		
		// ...и изменение размера Viewport OpenGL, по размеру окна
		glViewport(0, 0, rect.right, rect.bottom);
		break;
	case WM_KEYDOWN:
		//Angle += 5; // Увеличиваем угол поворота на 5 градусов
		//InvalidateRect(hWnd, 0, 0); // Перерисовываем окно
		
		
		
		break;
	case WM_DESTROY:
		GLShutdown(); // При выходе - очистка контекта OpenGL (hRC) и WinAPI GDI (hDC)
		PostQuitMessage(0);
		break;
	default:
		return DefWindowProc(hWnd, msg, wParam, lParam);
		break;
	}

	return 0;
}

void GLInit()
{
	// Получение контекста WinAPI GDI
	hDC = GetDC(hWnd);

	// Настройка формата пикселей
	PIXELFORMATDESCRIPTOR pfd;
	memset(&pfd, 0, sizeof(PIXELFORMATDESCRIPTOR));
	pfd.nSize      = sizeof(PIXELFORMATDESCRIPTOR);
	pfd.nVersion   = 1;
	pfd.dwFlags    = PFD_DRAW_TO_WINDOW
		| PFD_SUPPORT_OPENGL // Поддержка OpenGL
		| PFD_DOUBLEBUFFER; // Двойная буферизация (чтобы изображение не мерцало)
	pfd.iPixelType = PFD_TYPE_RGBA; // Пиксели поддерживают прозрачность Alpha (поэтому, RGBA, а не RGB)
	pfd.cColorBits = 16; // Глубина цвета - 16 бит
	pfd.cDepthBits = 16;

	int iPixelFormat = ChoosePixelFormat(hDC, &pfd);

	PIXELFORMATDESCRIPTOR bestMatch_pfd;
	DescribePixelFormat(hDC, iPixelFormat, sizeof(pfd), &bestMatch_pfd);

	SetPixelFormat(hDC, iPixelFormat, &pfd);

	// Создание контекста OpenGL
	hRC = wglCreateContext(hDC);
	wglMakeCurrent(hDC, hRC);

	// Заливка фона черным:
	// R     = 0/255   = 0.0
	// G     = 0/255   = 0.0
	// B     = 0/255   = 0.0
	// Alpha = 255/255 = 1.0
	glClearColor(0.0, 0.0, 0.0, 1.0);
}

void GLRenderScene()
{
	// Очищаем буфер цвета и глубины
	// чтобы старый (неповернутый) прямоугольник - стирался
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glLoadIdentity();

	// Поворачиваем сцену на угол Angle, по осям X (1.0), Y (1.0), но не Z (0.0)
	glRotatef(Angle, 1.0, 1.0, 0.0);

	// Цвет прямоугольника - темно-зеленый:
	// R = 0/255   = 0
	// G = 127/255 = 0.5
	// B = 0/255   = 0
	glColor3f(0.0, 0.5, 0.0);

	// Рисование прямоугольника
	// высота: 1 половина высоты окна =                      1.0 ед.
	// ширина: 0.25 ширины окна = 0.5 половины ширины окна = 0.5 ед.
	glBegin(GL_POLYGON);
	glVertex2f(0, 0); // Левый-нижний угол
	glVertex2f(0, 1.0); // Левый-верхний угол
	glVertex2f(0.5, 1.0); // Правый-верхний угол
	glVertex2f(0.5, 0); // Правый-нижний угол
	glEnd();
	
	DRAWQUAD();

	SwapBuffers(hDC);
}

void GLShutdown()
{
	if (hRC != NULL)
	{
		wglMakeCurrent(NULL, NULL); // Делаем NULL текущим контекстом OpenGL (восстанавливаем умолчание)
		wglDeleteContext(hRC); // Удаляем и обNULLяем наш контекст
		hRC = NULL;
	}

	if (hDC != NULL)
	{
		ReleaseDC(hWnd, hDC); // Удаляем и обNULLяем наш контекст WinAPI GDI
		hDC = NULL;
	}
}