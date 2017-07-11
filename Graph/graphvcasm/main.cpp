#define UNICODE

// WinAPI
#include <Windows.h>
#include <tchar.h>

// OpenGL
#pragma comment(lib, "Opengl32.lib")
#include <gl/GL.h>

// ���������� ���������
TCHAR *szWndClass = L"OpenGLWindow";

// ���������� ����������
HWND  hWnd;
HDC   hDC;
HGLRC hRC;

int Angle = 0;

// ������� ��� �������� ���� Win32
ATOM RegClass(HINSTANCE hInst);
HWND CreateWnd(HINSTANCE hInst);
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

extern "C" char * DRAWQUAD();

// ������� ��� ������ � OpenGL
void GLInit();
void GLRenderScene();
void GLShutdown();

int WINAPI wWinMain(HINSTANCE hInst, HINSTANCE hPrevInst, LPWSTR lpCmdLine, int nShowCmd)
{
	// ����������� ������ ����
	if (!RegClass(hInst))
	{
		MessageBox(0, L"�� ���� ���������������� ����� ����...", 0, 0);
		return 1;
	}

	// �������� ����
	hWnd = CreateWnd(hInst);
	if (hWnd == NULL)
	{
		MessageBox(0, L"�� ���� ������� ����...", 0, 0);
		return 1;
	}

	// ������������� OpenGL
	GLInit();

	// ������� ���� ����������
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
	// ��� �����������, ��� � ������, � WinAPI...
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
	wc.style = CS_HREDRAW | CS_VREDRAW; // ���� ���������������� ��� ������������

	return RegisterClass(&wc);
}

HWND CreateWnd(HINSTANCE hInst)
{
	// �������� ���� - �����, ���, ��� ������...
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
		GLRenderScene(); // ��������� (���������) �����
		EndPaint(hWnd, &ps);
		break;
	case WM_SIZE:
		// ��� ������������ - ��������� ������� ����...
		RECT rect;
		GetClientRect(hWnd, &rect);
		
		// ...� ��������� ������� Viewport OpenGL, �� ������� ����
		glViewport(0, 0, rect.right, rect.bottom);
		break;
	case WM_KEYDOWN:
		//Angle += 5; // ����������� ���� �������� �� 5 ��������
		//InvalidateRect(hWnd, 0, 0); // �������������� ����
		
		
		
		break;
	case WM_DESTROY:
		GLShutdown(); // ��� ������ - ������� �������� OpenGL (hRC) � WinAPI GDI (hDC)
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
	// ��������� ��������� WinAPI GDI
	hDC = GetDC(hWnd);

	// ��������� ������� ��������
	PIXELFORMATDESCRIPTOR pfd;
	memset(&pfd, 0, sizeof(PIXELFORMATDESCRIPTOR));
	pfd.nSize      = sizeof(PIXELFORMATDESCRIPTOR);
	pfd.nVersion   = 1;
	pfd.dwFlags    = PFD_DRAW_TO_WINDOW
		| PFD_SUPPORT_OPENGL // ��������� OpenGL
		| PFD_DOUBLEBUFFER; // ������� ����������� (����� ����������� �� �������)
	pfd.iPixelType = PFD_TYPE_RGBA; // ������� ������������ ������������ Alpha (�������, RGBA, � �� RGB)
	pfd.cColorBits = 16; // ������� ����� - 16 ���
	pfd.cDepthBits = 16;

	int iPixelFormat = ChoosePixelFormat(hDC, &pfd);

	PIXELFORMATDESCRIPTOR bestMatch_pfd;
	DescribePixelFormat(hDC, iPixelFormat, sizeof(pfd), &bestMatch_pfd);

	SetPixelFormat(hDC, iPixelFormat, &pfd);

	// �������� ��������� OpenGL
	hRC = wglCreateContext(hDC);
	wglMakeCurrent(hDC, hRC);

	// ������� ���� ������:
	// R     = 0/255   = 0.0
	// G     = 0/255   = 0.0
	// B     = 0/255   = 0.0
	// Alpha = 255/255 = 1.0
	glClearColor(0.0, 0.0, 0.0, 1.0);
}

void GLRenderScene()
{
	// ������� ����� ����� � �������
	// ����� ������ (������������) ������������� - ��������
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glLoadIdentity();

	// ������������ ����� �� ���� Angle, �� ���� X (1.0), Y (1.0), �� �� Z (0.0)
	glRotatef(Angle, 1.0, 1.0, 0.0);

	// ���� �������������� - �����-�������:
	// R = 0/255   = 0
	// G = 127/255 = 0.5
	// B = 0/255   = 0
	glColor3f(0.0, 0.5, 0.0);

	// ��������� ��������������
	// ������: 1 �������� ������ ���� =                      1.0 ��.
	// ������: 0.25 ������ ���� = 0.5 �������� ������ ���� = 0.5 ��.
	glBegin(GL_POLYGON);
	glVertex2f(0, 0); // �����-������ ����
	glVertex2f(0, 1.0); // �����-������� ����
	glVertex2f(0.5, 1.0); // ������-������� ����
	glVertex2f(0.5, 0); // ������-������ ����
	glEnd();
	
	DRAWQUAD();

	SwapBuffers(hDC);
}

void GLShutdown()
{
	if (hRC != NULL)
	{
		wglMakeCurrent(NULL, NULL); // ������ NULL ������� ���������� OpenGL (��������������� ���������)
		wglDeleteContext(hRC); // ������� � ��NULL��� ��� ��������
		hRC = NULL;
	}

	if (hDC != NULL)
	{
		ReleaseDC(hWnd, hDC); // ������� � ��NULL��� ��� �������� WinAPI GDI
		hDC = NULL;
	}
}