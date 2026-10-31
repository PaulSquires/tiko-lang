[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **DXGI interfaces and types**

# DXGI interfaces and types

Lists the DXGI interfaces, enumerations and structures of sys/win/direct2d.

**DXGI**, the DirectX Graphics Infrastructure, is the layer under Direct3D and Direct2D that
knows the graphics adapters, the monitors attached to them, and the surfaces and swap chains
that frames are drawn into and presented from. `sys/win/direct2d` declares its interfaces up to
the sixth factory so that Direct2D can be pointed at DXGI objects; it does not create Direct3D
devices.

**Where the objects meet sys/win.** The Direct2D classes take and give DXGI pointers:
[CD2D1Factory](CD2D1Factory) makes a render target on an `IDXGISurface`
(`CreateDxgiSurfaceRenderTarget`), its later versions build a Direct2D device on an
`IDXGIDevice` (`CreateDevice` … `CreateDevice7`), and `CID2D1Bitmap1.GetSurface` returns the
`IDXGISurface` behind a bitmap. The `IDXGIDevice` itself comes from a Direct3D device, by
`QueryInterface` with `IID_IDXGIDevice`.

**A factory of your own.** To list adapters and outputs without Direct3D, create a DXGI factory.
`sys/win/direct2d` declares one entry point,
`declare function CreateDXGIFactory2 lib "Dxgi" alias "CreateDXGIFactory2" ( byval flags as UINT, byref factory as any ptr ) as HRESULT`,
without the interface identifier that Windows' `CreateDXGIFactory2` expects between the two:
calling it as declared ended the test program with an access violation. Declare
`CreateDXGIFactory1` yourself, as the example does.

**Calling a method.** Each interface `IDXGIX` is a name for the type `IDXGIX_`, which declares
the methods and extends its parent, so `p->Method( ... )` calls one, and an `IDXGIFactory1 ptr`
also has every `IDXGIFactory` and `IDXGIObject` method. A parameter that receives an object is
`byref ... ptr`: pass the pointer variable. `IID_IDXGIObject` … `IID_IDXGIFactory7` are `GUID`
variables. Every pointer handed out holds one reference: call `Release` when done.

**Constants.** Besides the enumerations below, the module declares the `DXGI_USAGE_*`,
`DXGI_PRESENT_*`, `DXGI_MWA_*` (window association), `DXGI_MAP_*`, `DXGI_ENUM_MODES_*`,
`DXGI_RESOURCE_PRIORITY_*` and `DXGI_SHARED_RESOURCE_*` values as constants.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A console program that lists the graphics adapters, with their dedicated video memory, and the
outputs (monitors) of each:

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d

' The factory entry point that takes an interface identifier.
declare function CreateDXGIFactory1 lib "dxgi" alias "CreateDXGIFactory1" ( byref riid as IID, byref ppFactory as any ptr ) as HRESULT

function main() as long
    dim pFactory as IDXGIFactory1 ptr
    dim hr as HRESULT = CreateDXGIFactory1( IID_IDXGIFactory1, pFactory )
    if hr <> S_OK then print "CreateDXGIFactory1 failed: &h"; hex( hr ) : return 1

    ' Walk the graphics adapters, then the outputs (monitors) of each.
    dim i as UINT = 0
    dim pAdapter as IDXGIAdapter1 ptr
    while pFactory->EnumAdapters1( i, pAdapter ) = S_OK
        dim desc as DXGI_ADAPTER_DESC1
        pAdapter->GetDesc1( desc )
        dim sName as ustring = desc.Description
        print "adapter "; i; ": "; sName; ", "; desc.DedicatedVideoMemory \ ( 1024 * 1024 ); " MB";
        if desc.Flags and DXGI_ADAPTER_FLAG_SOFTWARE then print " (software)" else print
        dim j as UINT = 0
        dim pOutput as IDXGIOutput ptr
        while pAdapter->EnumOutputs( j, pOutput ) = S_OK
            dim od as DXGI_OUTPUT_DESC
            pOutput->GetDesc( od )
            with od.DesktopCoordinates
                print "    output "; j; ":"; .right - .left; " x"; .bottom - .top
            end with
            pOutput->Release()
            j += 1
        wend
        pAdapter->Release()
        i += 1
    wend
    pFactory->Release()
    return 0
end function

end main()
```

On a laptop it printed:

```text
adapter 0: Intel(R) Arc(TM) 140V GPU (8GB), 128 MB
    output 0: 1646 x 1029
adapter 1: Microsoft Basic Render Driver, 0 MB (software)
```

The program is not DPI aware, so the desktop rectangle is in scaled pixels; call
`SetProcessDpiAwareness` first for physical ones. The last adapter is the software renderer
that Windows provides.

## Types

The enumeration types are `long`s; their values are separate constants, written bare after
`using direct2d`. `DXGI_FORMAT`, `DXGI_MODE_DESC`, `DXGI_SAMPLE_DESC`, `DXGI_RATIONAL`,
`DXGI_RGB` and the other types shared with Direct2D are declared with it: see
[Direct2D interfaces](SysWin-Direct2D-Interfaces).

### Interfaces

| Interface | Methods declared in | Extends | Is | Microsoft Learn |
| --- | --- | --- | --- | --- |
| `IDXGIObject` | `IDXGIObject_` | `ComUnknown` | The base of every DXGI object: private data and the parent object. | [IDXGIObject](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgiobject) |
| `IDXGIDeviceSubObject` | `IDXGIDeviceSubObject_` | `IDXGIObject` | The base of objects that belong to a device: gives the device back. | [IDXGIDeviceSubObject](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgidevicesubobject) |
| `IDXGIResource` | `IDXGIResource_` | `IDXGIDeviceSubObject` | A resource that can be shared between devices: shared handle, usage, eviction priority. | [IDXGIResource](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgiresource) |
| `IDXGIKeyedMutex` | `IDXGIKeyedMutex_` | `IDXGIDeviceSubObject` | A lock on a shared surface, acquired and released with a key. | [IDXGIKeyedMutex](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgikeyedmutex) |
| `IDXGISurface` | `IDXGISurface_` | `IDXGIDeviceSubObject` | A 2D image: its description, and mapping its pixels into memory. A Direct2D bitmap or DXGI render target draws on one. | [IDXGISurface](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgisurface) |
| `IDXGISurface1` | `IDXGISurface1_` | `IDXGISurface` | Adds a GDI device context for the surface (`GetDC`, `ReleaseDC`). | [IDXGISurface1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgisurface1) |
| `IDXGIOutput` | `IDXGIOutput_` | `IDXGIObject` | A display output (a monitor): its description, display modes, vertical blank, gamma. | [IDXGIOutput](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgioutput) |
| `IDXGIAdapter` | `IDXGIAdapter_` | `IDXGIObject` | A display adapter (a graphics card or a software renderer): its outputs and description. | [IDXGIAdapter](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgiadapter) |
| `IDXGISwapChain` | `IDXGISwapChain_` | `IDXGIDeviceSubObject` | The buffers a window is presented from: `Present`, `GetBuffer`, `ResizeBuffers`, full-screen state. | [IDXGISwapChain](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgiswapchain) |
| `IDXGIFactory` | `IDXGIFactory_` | `IDXGIObject` | Enumerates adapters and creates swap chains. | [IDXGIFactory](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgifactory) |
| `IDXGIDevice` | `IDXGIDevice_` | `IDXGIObject` | The DXGI side of a Direct3D device: its adapter, GPU thread priority. Direct2D builds its device on one. | [IDXGIDevice](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgidevice) |
| `IDXGIAdapter1` | `IDXGIAdapter1_` | `IDXGIAdapter` | Adds a description with adapter flags (`GetDesc1`). | [IDXGIAdapter1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgiadapter1) |
| `IDXGIDevice1` | `IDXGIDevice1_` | `IDXGIDevice` | Adds the maximum frame latency. | [IDXGIDevice1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgidevice1) |
| `IDXGIFactory1` | `IDXGIFactory1_` | `IDXGIFactory` | Adds `EnumAdapters1` and a test for whether the factory is current. | [IDXGIFactory1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nn-dxgi-idxgifactory1) |
| `IDXGIOutputDuplication` | `IDXGIOutputDuplication_` | `IDXGIObject` | A copy of the desktop image of one output, frame by frame, for screen capture. | [IDXGIOutputDuplication](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/nn-dxgi1_2-idxgioutputduplication) |
| `IDXGISurface2` | `IDXGISurface2_` | `IDXGISurface1` | Adds the resource a subresource surface belongs to. | [IDXGISurface2](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/nn-dxgi1_2-idxgisurface2) |
| `IDXGIResource1` | `IDXGIResource1_` | `IDXGIResource` | Adds subresource surfaces and named shared handles. | [IDXGIResource1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/nn-dxgi1_2-idxgiresource1) |
| `IDXGIDisplayControl` | `IDXGIDisplayControl_` | `ComUnknown` | Turns stereo display on and off. | [IDXGIDisplayControl](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/nn-dxgi1_2-idxgidisplaycontrol) |
| `IDXGIDevice2` | `IDXGIDevice2_` | `IDXGIDevice1` | Adds offering and reclaiming resources, and an event when the queue is done. | [IDXGIDevice2](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/nn-dxgi1_2-idxgidevice2) |
| `IDXGISwapChain1` | `IDXGISwapChain1_` | `IDXGISwapChain` | Adds a second-generation description, `Present1`, background colour and rotation. | [IDXGISwapChain1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/nn-dxgi1_2-idxgiswapchain1) |
| `IDXGIFactory2` | `IDXGIFactory2_` | `IDXGIFactory1` | Adds swap chains for a window (`CreateSwapChainForHwnd`), for a core window and for composition, and stereo and occlusion notifications. | [IDXGIFactory2](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/nn-dxgi1_2-idxgifactory2) |
| `IDXGIAdapter2` | `IDXGIAdapter2_` | `IDXGIAdapter1` | Adds a description with preemption granularity (`GetDesc2`). | [IDXGIAdapter2](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/nn-dxgi1_2-idxgiadapter2) |
| `IDXGIOutput1` | `IDXGIOutput1_` | `IDXGIOutput` | Adds display modes in the second-generation format and `DuplicateOutput`. | [IDXGIOutput1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/nn-dxgi1_2-idxgioutput1) |
| `IDXGIDevice3` | `IDXGIDevice3_` | `IDXGIDevice2` | Adds `Trim`, which frees memory a suspended app no longer needs. | [IDXGIDevice3](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/nn-dxgi1_3-idxgidevice3) |
| `IDXGISwapChain2` | `IDXGISwapChain2_` | `IDXGISwapChain1` | Adds source size, frame latency waitable object and matrix transform. | [IDXGISwapChain2](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/nn-dxgi1_3-idxgiswapchain2) |
| `IDXGIOutput2` | `IDXGIOutput2_` | `IDXGIOutput1` | Adds a test for multiplane overlay support. | [IDXGIOutput2](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/nn-dxgi1_3-idxgioutput2) |
| `IDXGIFactory3` | `IDXGIFactory3_` | `IDXGIFactory2` | Adds the flags the factory was created with. | [IDXGIFactory3](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/nn-dxgi1_3-idxgifactory3) |
| `IDXGIDecodeSwapChain` | `IDXGIDecodeSwapChain_` | `ComUnknown` | A swap chain that presents decoded video buffers. | [IDXGIDecodeSwapChain](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/nn-dxgi1_3-idxgidecodeswapchain) |
| `IDXGIFactoryMedia` | `IDXGIFactoryMedia_` | `ComUnknown` | Creates swap chains from a composition surface handle, for video. | [IDXGIFactoryMedia](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/nn-dxgi1_3-idxgifactorymedia) |
| `IDXGISwapChainMedia` | `IDXGISwapChainMedia_` | `ComUnknown` | Media frame statistics and custom present duration. | [IDXGISwapChainMedia](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/nn-dxgi1_3-idxgiswapchainmedia) |
| `IDXGIOutput3` | `IDXGIOutput3_` | `IDXGIOutput2` | Adds the overlay support test for a format. | [IDXGIOutput3](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/nn-dxgi1_3-idxgioutput3) |
| `IDXGISwapChain3` | `IDXGISwapChain3_` | `IDXGISwapChain2` | Adds the current back-buffer index and colour spaces. | [IDXGISwapChain3](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_4/nn-dxgi1_4-idxgiswapchain3) |
| `IDXGIOutput4` | `IDXGIOutput4_` | `IDXGIOutput3` | Adds the overlay colour-space support test. | [IDXGIOutput4](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_4/nn-dxgi1_4-idxgioutput4) |
| `IDXGIFactory4` | `IDXGIFactory4_` | `IDXGIFactory3` | Adds finding an adapter by LUID and the WARP software adapter. | [IDXGIFactory4](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_4/nn-dxgi1_4-idxgifactory4) |
| `IDXGIAdapter3` | `IDXGIAdapter3_` | `IDXGIAdapter2` | Adds video memory budgets and reservations, and content protection notices. | [IDXGIAdapter3](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_4/nn-dxgi1_4-idxgiadapter3) |
| `IDXGIOutput5` | `IDXGIOutput5_` | `IDXGIOutput4` | Adds output duplication for a list of formats. | [IDXGIOutput5](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_5/nn-dxgi1_5-idxgioutput5) |
| `IDXGISwapChain4` | `IDXGISwapChain4_` | `IDXGISwapChain3` | Adds HDR metadata. | [IDXGISwapChain4](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_5/nn-dxgi1_5-idxgiswapchain4) |
| `IDXGIDevice4` | `IDXGIDevice4_` | `IDXGIDevice3` | Adds offering and reclaiming resources with flags. | [IDXGIDevice4](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_5/nn-dxgi1_5-idxgidevice4) |
| `IDXGIFactory5` | `IDXGIFactory5_` | `IDXGIFactory4` | Adds a feature test, such as tearing support. | [IDXGIFactory5](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_5/nn-dxgi1_5-idxgifactory5) |
| `IDXGIAdapter4` | `IDXGIAdapter4_` | `IDXGIAdapter3` | Adds a description with the third-generation flags (`GetDesc3`). | [IDXGIAdapter4](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_6/nn-dxgi1_6-idxgiadapter4) |
| `IDXGIOutput6` | `IDXGIOutput6_` | `IDXGIOutput5` | Adds a description with colour data (`GetDesc1`) and hardware composition support. | [IDXGIOutput6](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_6/nn-dxgi1_6-idxgioutput6) |
| `IDXGIFactory6` | `IDXGIFactory6_` | `IDXGIFactory5` | Adds enumerating adapters by GPU preference (low power or high performance). | [IDXGIFactory6](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_6/nn-dxgi1_6-idxgifactory6) |
| — | `IDXGIFactory7_` | `IDXGIFactory6` | Adds an event raised when adapters are added or removed. The methods are there under `IDXGIFactory7_`; no `IDXGIFactory7` name is declared. | [IDXGIFactory7](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_6/nn-dxgi1_6-idxgifactory7) |

### Enumerations

| Type | Values | Is | Microsoft Learn |
| --- | --- | --- | --- |
| `DXGI_SWAP_EFFECT` | `DXGI_SWAP_EFFECT_*` | How presented buffers are handled: discard, sequential, flip-sequential, flip-discard. | [DXGI_SWAP_EFFECT](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ne-dxgi-dxgi_swap_effect) |
| `DXGI_RESIDENCY` | `DXGI_RESIDENCY_*` | Whether a resource is in video memory, shared memory or evicted. | [DXGI_RESIDENCY](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ne-dxgi-dxgi_residency) |
| `DXGI_SWAP_CHAIN_FLAG` | `DXGI_SWAP_CHAIN_FLAG_*` | Swap-chain options: GDI compatible, allow mode switch, waitable object, allow tearing … | [DXGI_SWAP_CHAIN_FLAG](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ne-dxgi-dxgi_swap_chain_flag) |
| `DXGI_ADAPTER_FLAG` | `DXGI_ADAPTER_FLAG_*` | Kind of adapter: remote or software. | [DXGI_ADAPTER_FLAG](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ne-dxgi-dxgi_adapter_flag) |
| `DXGI_OFFER_RESOURCE_PRIORITY` | `DXGI_OFFER_RESOURCE_PRIORITY_*` | How important an offered resource is. | [DXGI_OFFER_RESOURCE_PRIORITY](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ne-dxgi1_2-dxgi_offer_resource_priority) |
| `DXGI_ALPHA_MODE` | `DXGI_ALPHA_MODE_*` | How a swap chain treats alpha: unspecified, premultiplied, straight, ignore. | [DXGI_ALPHA_MODE](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ne-dxgi1_2-dxgi_alpha_mode) |
| `DXGI_OUTDUPL_POINTER_SHAPE_TYPE` | `DXGI_OUTDUPL_POINTER_SHAPE_TYPE_*` | The kind of mouse pointer shape in a duplicated frame. | [DXGI_OUTDUPL_POINTER_SHAPE_TYPE](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ne-dxgi1_2-dxgi_outdupl_pointer_shape_type) |
| `DXGI_SCALING` | `DXGI_SCALING_*` | How the back buffer is fitted to the target: stretch, none, aspect-ratio stretch. | [DXGI_SCALING](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ne-dxgi1_2-dxgi_scaling) |
| `DXGI_GRAPHICS_PREEMPTION_GRANULARITY` | `DXGI_GRAPHICS_PREEMPTION_*` | How finely the GPU can interrupt graphics work. | [DXGI_GRAPHICS_PREEMPTION_GRANULARITY](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ne-dxgi1_2-dxgi_graphics_preemption_granularity) |
| `DXGI_COMPUTE_PREEMPTION_GRANULARITY` | `DXGI_COMPUTE_PREEMPTION_*` | How finely the GPU can interrupt compute work. | [DXGI_COMPUTE_PREEMPTION_GRANULARITY](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ne-dxgi1_2-dxgi_compute_preemption_granularity) |
| `DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS` | `DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAG_*` | YCbCr options of a decode swap chain: nominal range, BT.709, xvYCC. | [DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/ne-dxgi1_3-dxgi_multiplane_overlay_ycbcr_flags) |
| `DXGI_FRAME_PRESENTATION_MODE` | `DXGI_FRAME_PRESENTATION_MODE_*` | How a frame of a media swap chain was shown: composed, overlay, none, composition failure. | [DXGI_FRAME_PRESENTATION_MODE](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/ne-dxgi1_3-dxgi_frame_presentation_mode) |
| `DXGI_OVERLAY_SUPPORT_FLAG` | `DXGI_OVERLAY_SUPPORT_FLAG_*` | Overlay support: direct, scaling. | [DXGI_OVERLAY_SUPPORT_FLAG](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/ne-dxgi1_3-dxgi_overlay_support_flag) |
| `DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG` | `DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_*` | Whether a colour space can be presented, or presented in an overlay. | [DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_4/ne-dxgi1_4-dxgi_swap_chain_color_space_support_flag) |
| `DXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG` | `DXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG_*` | Whether an overlay supports a colour space. | [DXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_4/ne-dxgi1_4-dxgi_overlay_color_space_support_flag) |
| `DXGI_MEMORY_SEGMENT_GROUP` | `DXGI_MEMORY_SEGMENT_GROUP_*` | Local (dedicated) or non-local video memory. | [DXGI_MEMORY_SEGMENT_GROUP](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_4/ne-dxgi1_4-dxgi_memory_segment_group) |
| `DXGI_OUTDUPL_FLAG` | `DXGI_OUTDUPL_COMPOSITED_UI_CAPTURE_ONLY` | Output duplication option: capture only the composited UI. | — |
| `DXGI_HDR_METADATA_TYPE` | `DXGI_HDR_METADATA_TYPE_*` | Kind of HDR metadata: none, HDR10, HDR10+. | [DXGI_HDR_METADATA_TYPE](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_5/ne-dxgi1_5-dxgi_hdr_metadata_type) |
| `DXGI_OFFER_RESOURCE_FLAGS` | `DXGI_OFFER_RESOURCE_FLAG_ALLOW_DECOMMIT` | Options for offering resources: allow decommit. | [DXGI_OFFER_RESOURCE_FLAGS](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_5/ne-dxgi1_5-dxgi_offer_resource_flags) |
| `DXGI_RECLAIM_RESOURCE_RESULTS` | `DXGI_RECLAIM_RESOURCE_RESULT_*` | What happened to a reclaimed resource: OK, discarded, not committed. | [DXGI_RECLAIM_RESOURCE_RESULTS](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_5/ne-dxgi1_5-dxgi_reclaim_resource_results) |
| `DXGI_FEATURE` | `DXGI_FEATURE_*` | A feature to test with `CheckFeatureSupport`: tearing. | [DXGI_FEATURE](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_5/ne-dxgi1_5-dxgi_feature) |
| `DXGI_ADAPTER_FLAG3` | `DXGI_ADAPTER_FLAG3_*` | Adapter flags of `DXGI_ADAPTER_DESC3`: remote, software, ACG compatible, fences, keyed-mutex conformance | [DXGI_ADAPTER_FLAG3](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_6/ne-dxgi1_6-dxgi_adapter_flag3) |
| `DXGI_HARDWARE_COMPOSITION_SUPPORT_FLAGS` | `DXGI_HARDWARE_COMPOSITION_SUPPORT_FLAG_*` | Hardware composition support: full screen, windowed, cursor stretched. | [DXGI_HARDWARE_COMPOSITION_SUPPORT_FLAGS](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_6/ne-dxgi1_6-dxgi_hardware_composition_support_flags) |
| `DXGI_GPU_PREFERENCE` | `DXGI_GPU_PREFERENCE_*` | Which adapter to list first: unspecified, minimum power, high performance. | [DXGI_GPU_PREFERENCE](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_6/ne-dxgi1_6-dxgi_gpu_preference) |

### Structures

| Type | Is | Microsoft Learn |
| --- | --- | --- |
| `DXGI_SURFACE_DESC` | Width, height, format and multisampling of a surface. | [DXGI_SURFACE_DESC](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ns-dxgi-dxgi_surface_desc) |
| `DXGI_MAPPED_RECT` | The pitch and pixel pointer of a mapped surface. | [DXGI_MAPPED_RECT](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ns-dxgi-dxgi_mapped_rect) |
| `DXGI_OUTPUT_DESC` | Device name, desktop rectangle, rotation and monitor handle of an output. | [DXGI_OUTPUT_DESC](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ns-dxgi-dxgi_output_desc) |
| `DXGI_FRAME_STATISTICS` | Present and refresh counts and their timestamps. | [DXGI_FRAME_STATISTICS](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ns-dxgi-dxgi_frame_statistics) |
| `DXGI_ADAPTER_DESC` | Adapter name, vendor and device ids, memory sizes and LUID. | [DXGI_ADAPTER_DESC](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ns-dxgi-dxgi_adapter_desc) |
| `DXGI_SWAP_CHAIN_DESC` | Everything `CreateSwapChain` needs: buffer mode, sample count, usage, buffer count, window, swap effect. | [DXGI_SWAP_CHAIN_DESC](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ns-dxgi-dxgi_swap_chain_desc) |
| `DXGI_SHARED_RESOURCE` | A shared resource handle. | [DXGI_SHARED_RESOURCE](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ns-dxgi-dxgi_shared_resource) |
| `DXGI_ADAPTER_DESC1` | `DXGI_ADAPTER_DESC` plus `DXGI_ADAPTER_FLAG` flags. | [DXGI_ADAPTER_DESC1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ns-dxgi-dxgi_adapter_desc1) |
| `DXGI_DISPLAY_COLOR_SPACE` | Primary and white-point coordinates of a display. | [DXGI_DISPLAY_COLOR_SPACE](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ns-dxgi-dxgi_display_color_space) |
| `DXGI_OUTDUPL_MOVE_RECT` | A region moved from one place of the desktop to another. | [DXGI_OUTDUPL_MOVE_RECT](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_outdupl_move_rect) |
| `DXGI_OUTDUPL_DESC` | Mode, rotation and memory location of a duplicated desktop image. | [DXGI_OUTDUPL_DESC](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_outdupl_desc) |
| `DXGI_OUTDUPL_POINTER_POSITION` | Position and visibility of the mouse pointer. | [DXGI_OUTDUPL_POINTER_POSITION](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_outdupl_pointer_position) |
| `DXGI_OUTDUPL_POINTER_SHAPE_INFO` | Type, size, pitch and hot spot of the pointer shape. | [DXGI_OUTDUPL_POINTER_SHAPE_INFO](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_outdupl_pointer_shape_info) |
| `DXGI_OUTDUPL_FRAME_INFO` | Timestamps, frame counts and pointer data of a duplicated frame. | [DXGI_OUTDUPL_FRAME_INFO](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_outdupl_frame_info) |
| `DXGI_MODE_DESC1` | A display mode, with stereo. | [DXGI_MODE_DESC1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_mode_desc1) |
| `DXGI_SWAP_CHAIN_DESC1` | The description `CreateSwapChainForHwnd` takes: size, format, buffers, scaling, swap effect, alpha mode. | [DXGI_SWAP_CHAIN_DESC1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_swap_chain_desc1) |
| `DXGI_SWAP_CHAIN_FULLSCREEN_DESC` | Refresh rate, scan-line order, scaling and windowed state of a full-screen swap chain. | [DXGI_SWAP_CHAIN_FULLSCREEN_DESC](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_swap_chain_fullscreen_desc) |
| `DXGI_PRESENT_PARAMETERS` | Dirty rectangles and scroll information for `Present1`. | [DXGI_PRESENT_PARAMETERS](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_present_parameters) |
| `DXGI_ADAPTER_DESC2` | Adds preemption granularity to the adapter description. | [DXGI_ADAPTER_DESC2](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_adapter_desc2) |
| `DXGI_MATRIX_3X2_F` | A 3 × 2 transform matrix for a swap chain. | [DXGI_MATRIX_3X2_F](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/ns-dxgi1_3-dxgi_matrix_3x2_f) |
| `DXGI_DECODE_SWAP_CHAIN_DESC` | Flags of a decode swap chain. | [DXGI_DECODE_SWAP_CHAIN_DESC](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/ns-dxgi1_3-dxgi_decode_swap_chain_desc) |
| `DXGI_FRAME_STATISTICS_MEDIA` | Frame statistics with the composition mode and approved duration. | [DXGI_FRAME_STATISTICS_MEDIA](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/ns-dxgi1_3-dxgi_frame_statistics_media) |
| `DXGI_QUERY_VIDEO_MEMORY_INFO` | Video memory budget, usage and reservations. | [DXGI_QUERY_VIDEO_MEMORY_INFO](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_4/ns-dxgi1_4-dxgi_query_video_memory_info) |
| `DXGI_HDR_METADATA_HDR10` | HDR10 mastering-display and content light levels. | [DXGI_HDR_METADATA_HDR10](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_5/ns-dxgi1_5-dxgi_hdr_metadata_hdr10) |
| `DXGI_HDR_METADATA_HDR10PLUS` | An HDR10+ metadata block (72 bytes). | — |
| `DXGI_ADAPTER_DESC3` | The adapter description with `DXGI_ADAPTER_FLAG3` flags. | [DXGI_ADAPTER_DESC3](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_6/ns-dxgi1_6-dxgi_adapter_desc3) |
| `DXGI_OUTPUT_DESC1` | The output description with bits per colour, colour space, primaries and luminance. | [DXGI_OUTPUT_DESC1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_6/ns-dxgi1_6-dxgi_output_desc1) |

### Other types

| Type | Declared as | Is | Microsoft Learn |
| --- | --- | --- | --- |
| `DXGI_USAGE` | `UINT` | Usage flags of a surface or back buffer: the `DXGI_USAGE_*` constants (`DXGI_USAGE_RENDER_TARGET_OUTPUT` …). | [DXGI_USAGE](https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/dxgi-usage) |

## Using the interfaces

The parent of an object, by identifier: here the factory an adapter belongs to.

**Example**

```freebasic
dim pAdapter as IDXGIAdapter ptr       ' from IDXGIFactory.EnumAdapters
dim pParent as IDXGIFactory ptr
if pAdapter then pAdapter->GetParent( IID_IDXGIFactory, pParent )
```

The adapter a Direct3D device runs on, from its `IDXGIDevice`:

**Example**

```freebasic
dim pDxgiDevice as IDXGIDevice ptr     ' QueryInterface of a Direct3D device with IID_IDXGIDevice
dim pAdapter as IDXGIAdapter ptr
if pDxgiDevice then pDxgiDevice->GetAdapter( pAdapter )
```

`IDXGIFactory7` is not declared as a name; its methods are on `IDXGIFactory7_`:

**Example**

```freebasic
dim pF7 as IDXGIFactory7_ ptr          ' QueryInterface with IID_IDXGIFactory7
dim dwCookie as DWORD
if pF7 then pF7->RegisterAdaptersChangedEvent( CreateEventW( NULL, false, false, NULL ), dwCookie )
```

Microsoft Learn: [DXGI](https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/dx-graphics-dxgi),
[CreateDXGIFactory1](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/nf-dxgi-createdxgifactory1),
[CreateDXGIFactory2](https://learn.microsoft.com/en-us/windows/win32/api/dxgi1_3/nf-dxgi1_3-createdxgifactory2)

## See also

- [sys/win/direct2d](SysWin-Direct2D)
- [CD2D1Factory](CD2D1Factory) for render targets and devices on DXGI objects
- [Direct2D render targets](SysWin-Direct2D-Render-Targets), [Direct2D bitmaps](SysWin-Direct2D-Bitmaps)
- [Direct2D interfaces](SysWin-Direct2D-Interfaces), [DirectWrite interfaces and types](SysWin-DirectWrite-Interfaces), [WIC interfaces and types](SysWin-WIC-Interfaces)
- [Display, screen and DPI](SysWin-Display-and-DPI)
